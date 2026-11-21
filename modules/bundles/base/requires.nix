# every machine has to say what its drive looks like, what manages its
# network and what it shows once it is up. requiring those parts
# here makes their settings mandatory: leave one unset and the build says so
{
  requires.base = [
    "disk"
    "network"
    "session"
  ];
}
