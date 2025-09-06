class Proficiency {
  int notCompleted;
  int completed;
  int resubmit;
  int pastDue;

  Proficiency({
    this.notCompleted = 0,
    this.completed = 0,
    this.resubmit = 0,
    this.pastDue = 0,
  });
  int get totalCount {
    return notCompleted + completed + resubmit + pastDue;
  }
}
