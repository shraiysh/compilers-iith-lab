# IPTables

Iptables is a Linux utility administration tool for IPv4/6 packet filtering and NAT.
Iptables is used to set up, maintain, and inspect the tables of IP packet filter rules in the
Linux kernel. (Excerpt: Linux man page)

In simpler words, the Iptables specifies the action to be taken on an incoming/outgoing
packet from a specific source IP and the destination IP.

The motive of this question is to use Lex/Yacc to parse the incoming Iptables rules,
process it and print the structure of the resulting Iptables. To make the problem easier,
let us restrict the actual syntax/semantics of Iptables to consider the following reduced
man page specification with the restricted usage, commands, and options.

For full problem description, check [Question Paper](#)

### How to run?

```bash
make
./p1.out < test.txt	# test.txt is the input file
```
