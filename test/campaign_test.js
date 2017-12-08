const Campaign = artifacts.require("./Campaign.sol");

contract('Campaign', accounts => {

  let contract = null;
  const goal = 1000;
  const duration = 10;
  const owner = accounts[0];

  beforeEach("prepare", () => {
    return new Campaign.new(duration, goal, { from: owner }).
      then(instance => { contract = instance });
  })

  it("should just say hello", () => {
    assert.strictEqual(true, true, "Something is wrong.");
  });
});
