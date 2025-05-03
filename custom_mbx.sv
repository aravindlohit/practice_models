class my_mailbox #(type T );

  T queue[$];               // Dynamic queue
  semaphore sem;            // For blocking on empty queue

  // Constructor
  function new();
    sem = new(0);           // 0 tokens initially
  endfunction

  // Blocking put
 function void put(T item);
    queue.push_back(item);
    sem.put(1);             // Signal one item available
 endfunction

  // Blocking get — this must be a task
  task get(ref T item);
    sem.get(1);             // Wait for item (legal in a task)
    item = queue.pop_front();
  endtask

endclass
   
module test;

  class packet;
    rand int addr;
    rand bit [3:0] data;

    function void display();
      $display("addr = %0d, data = %0d", addr, data);
    endfunction
  endclass

  my_mailbox#(packet) mbx;

  initial begin
    packet p = new();
    p.randomize();

    mbx = new();
    mbx.put(p);

    #5;
    read_packet();
  end

  task read_packet();
    packet p;
    mbx.get(p);
    p.display();
  endtask

endmodule
