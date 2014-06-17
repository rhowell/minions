Minions
===
You're busy, too busy.  There are always so many enemies to vanquish and planets to conquer.  What a future emperor of the universe like you needs is minions.  Minions are great! They do what you ask without question, and if they get killed in the line of duty? Meh!  There's always another one ready to take its place, in loyal service to you.

Minions is a Ruby gem for actor based systems.  This is my take on a distributed system compatible with MRI, Rubinius, & JRuby implementations.


The Plan
---

Minions will be an ambitious undertaking, with lots of complex, moving parts.  I'm planning to tackle this in phases, with solid test coverage along the way.

Phase 1
---

Phase 1 will involve writing most of the base classes, such as mailboxes, routers, actors, and supervisors.  These will all run serially, however.  If actors die, their mailboxes will be preserved (along with the current message being processed), and their supervisor will be notified to take appropriate action.

Phase 2
---

The system will be expanded to run in parallel across a single VM.  This may require implementation specific code to best make use of the facilities availibe via MRI, Rubinius, & JRuby.

Phase 3
---

Phase 3, A.K.A. The tricky bastard.  We cross the boundaries of the VMs.  Messages can be sent across the network to actors running on many different machines.  This will require the most in depth thought, as it is important that configuring multiple machines and managing events be straight forward and reliable.

