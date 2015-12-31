// Description:
//   Submits code to the server.
//
// Dependencies:
//
// Configuration:
//   None
//
// Commands:
//   hubot debug - tells you what you can submit
//   hubot submit NAME - submit a PR to the server
//
// Author:
//   matsko
module.exports = function(robot) {
  var PRS = {
    "latest": "Your latest PR is set and it's testing against travis",
    "first": "I have no clue what your first PR was",
    "matsko": "Matias has over 100 PRs waiting for Angular2",
    "igor": "Igor is the king",
    "1234": "Yegor took care of this issue"
  };

  robot.hear(/cheese/, function(res) {
    res.send("Did somebody say cheese?");
  });

  robot.respond(/submit\s+(.+)/i, submit);
  robot.respond(/debug/i, debug);

  function debug(res) {
    res.reply("Possible values: (ngbot submit [" + Object.keys(PRS).join(", ") + "])")
  }

  function submit(res) {
    pr = res.match[1]
    if (!pr || pr.length == 0) {
      res.reply("You need to enter in something") ;
      return;
    }

    if (isRepeated(robot.brain, res.message.user.id, pr)) {
      res.reply("You just asked that man...");
      return;
    }

    status = PRS[pr];
    if (!status || status.length == 0) {
      status = "Error: PR not found";
    }

    cacheMessage(robot.brain, res.message.user.id, pr);
    res.reply(status);
  }

  function cacheMessage(cache, id, pr) {
    cache[id] = pr;
  }

  function isRepeated(cache, id, pr) {
    return cache[id] == pr;
  }
};
