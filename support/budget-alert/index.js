const {CloudBillingClient} = require('@google-cloud/billing');
const functions = require('@google-cloud/functions-framework');

const PROJECT_ID = process.env.GOOGLE_CLOUD_PROJECT;
const PROJECT_NAME = `projects/${PROJECT_ID}`;
const billing = new CloudBillingClient();

// Register a CloudEvent function with the Functions Framework
functions.cloudEvent('budget-alert', async cloudEvent => {
  console.log(cloudEvent);
  const pubsubData = JSON.parse(
    Buffer.from(cloudEvent.data.message.data, 'base64').toString()
  );

  console.log(`Cost: ${pubsubData.costAmount}. Budget: ${pubsubData.budgetAmount}`)
  if (pubsubData.costAmount <= pubsubData.budgetAmount) {
    console.log(`No action necessary. (Current cost: ${pubsubData.costAmount})`);
    return `No action necessary. (Current cost: ${pubsubData.costAmount})`;
  }

  if (!PROJECT_ID) {
    console.log("No project specified");
    return 'No project specified';
  }

  const billingEnabled = await _isBillingEnabled(PROJECT_NAME);

  if (billingEnabled) {
    console.log("Starting to disable logging");
    return _disableBillingForProject(PROJECT_NAME);
  } else {
    console.log("Billing already disabled");
    return 'Billing already disabled';
  }
});


/**
 * Determine whether billing is enabled for a project
 * @param {string} projectName Name of project to check if billing is enabled
 * @return {bool} Whether project has billing enabled or not
 */
const _isBillingEnabled = async projectName => {
  try {
    const [res] = await billing.getProjectBillingInfo({name: projectName});
    return res.billingEnabled;
  } catch (e) {
    console.log(
      'Unable to determine if billing is enabled on specified project, assuming billing is enabled'
    );
    return true;
  }
};

/**
 * Disable billing for a project by removing its billing account
 * @param {string} projectName Name of project disable billing on
 * @return {string} Text containing response from disabling billing
 */
const _disableBillingForProject = async projectName => {
  const [res] = await billing.updateProjectBillingInfo({
    name: projectName,
    resource: {billingAccountName: ''}, // Disable billing
  });
  return `Billing disabled: ${JSON.stringify(res)}`;
};
