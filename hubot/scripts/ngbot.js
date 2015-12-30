module.exports = function(robot) {
  robot.hear(/hello/, function() {
    robot.respond("hello there");
  });
}
