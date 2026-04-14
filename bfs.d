// this software implements the BFS algorithm, here we use the words branch (edge) and node (vertex)

// import the tools we need
import std.algorithm : canFind;
import std.stdio : write, writeln;

// this structure will represent a branch in the graph
struct Branch
{
    // this is the weight of the branch
    float weight;
    // these are the nodes which form the branch
    Node start, end;

    // this is the constructor
    this (Node start, Node end, float weight)
    {
        this.start = start, this.end = end;
        this.weight = weight;
    }
}

// this class will represent a node in the graph
class Node
{
    // this is the name of the node
    char name;
    // this is the distance from the origin
    float distance;
    // this is the predecessor node
    Node predecessor;
    // this array will contain all the branches which are connected to this node
    Branch[] branches;

    // this is the constructor
    this (char name, float distance, Node predecessor)
    {
        this.name = name;
        this.distance = distance;
        this.predecessor = predecessor;
    }

    // this member function will print all the data of the node
    void show()
    {
        // print the name and distance of the node
        write(this.name, ' ', this.distance);

        // if it has a predecessor
        if (this.predecessor !is null)
            // print the name of the predecessor
            writeln(' ', this.predecessor.name);
        // else, meaning it doesn't have a predecessor
        else
            // just add a new line in the end
            writeln();
    }
}

// start the program
void main()
{
    // this string will contain the BFS ordering after the search is done
    string ordering;

    // create all the nodes, they are fresh nodes with no distance and no predecessor
    Node A = new Node('A', float.infinity, null), B = new Node('B', float.infinity, null), C = new Node('C', float.infinity, null),
        D = new Node('D', float.infinity, null), E = new Node('E', float.infinity, null), F = new Node('F', float.infinity, null),
        G = new Node('G', float.infinity, null), H = new Node('H', float.infinity, null);

    // create all the branches
    Branch AtoB = Branch(A, B, 1.0), AtoC = Branch(A, C, 4.0),
        BtoA = Branch(B, A, 1.0), BtoC = Branch(B, C, 3.0), BtoD = Branch(B, D, 1.0), BtoE = Branch(B, E, 1.0), BtoG = Branch(B, G, 3.0),
        CtoA = Branch(C, A, 4.0), CtoB = Branch(C, B, 3.0), CtoG = Branch(C, G, 5.0),
        DtoB = Branch(D, B, 1.0), DtoF = Branch(D, F, 1.0), DtoG = Branch(D, G, 2.0),
        EtoB = Branch(E, B, 1.0), EtoG = Branch(E, G, 2.0),
        FtoD = Branch(F, D, 1.0), FtoG = Branch(F, G, 2.0), FtoH = Branch(F, H, 1.0),
        GtoB = Branch(G, B, 3.0), GtoC = Branch(G, C, 5.0), GtoD = Branch(G, D, 2.0), GtoE = Branch(G, E, 2.0), GtoH = Branch(G, H, 1.0);

    // give all nodes their corresponding branches
    A.branches = [AtoB, AtoC], B.branches = [BtoA, BtoC, BtoD, BtoE, BtoG], C.branches = [CtoA, CtoB, CtoG], D.branches = [DtoB, DtoF, DtoG],
        E.branches = [EtoB, EtoG], F.branches = [FtoD, FtoG, FtoH], G.branches = [GtoB, GtoC, GtoD, GtoE, GtoH];

    // 'origin' will be where we start, 'destination' will be where we are going, 'current' and 'visited' will be used during the search
    Node origin = A, destination = H, current, visited;
    // set the distance of the origin to 0
    origin.distance = 0.0;

    // start a loop to check all nodes inside a queue until the queue is empty
    for (Node[] queue = [origin]; queue.length > 0;)
    {
        // get the 1st element of the queue and make it the current node
        current = queue[0];
        // pop the 1st element of the queue
        queue = queue[1 .. $];

        // start a loop to check all branches (edges) of the current node
        foreach (edge; current.branches)
        {
            // the node at the end of the branch will be the node we are visiting right now
            visited = edge.end;

            // if the distance of the visited node is bigger than that of the current node + the weight of the branch
            if (visited.distance > current.distance + edge.weight)
            {
                // set the distance of the visited node to be that of the current node + the weight of the branch (this should always result in a FP number
                // which is bigger than 0)
                visited.distance = current.distance + edge.weight;
                // set the predecessor of the visited node to be the current node
                visited.predecessor = current;

                // if the visited node is not in the queue and it is not the destination node
                if (!canFind(queue, visited) && visited !is destination)
                    // append the visited node to the queue
                    queue ~= visited;
            }
        }
    }

    // if the destination node ended up with no predecessor
    if (destination.predecessor is null)
        // print a message saying there is no path
        writeln("No path.");
    // else, meaning the destination node has a predecessor
    else
    {
        // start a loop to backtrack from the destination node all the way to the origin node
        for (current = destination; current !is null; current = current.predecessor)
            // add the name of the current node to the beginning of the BFS ordering string
            ordering = current.name ~ ordering;

        // print the BFS ordering string (it should be a string with only capital letters in it, as in "ABCDFH")
        writeln(ordering);
    }

    // show all the information of all nodes to the user (it will print the name, distance and predecessor of the node)
    A.show(), B.show(), C.show(), D.show(), E.show(), F.show(), G.show(), H.show();
}
