// this software implements the BFS algorithm, here we use the words branch (edge) and node (vertex)

// import the tools we need
import std.stdio : write, writeln;

// this struct will represent a branch (edge)
struct Branch
{
    // this is the weight of the branch
    float weight;
    // these will be the start node and the end node which define the branch
    Node start, end;

    // this is the constructor
    this (float weight, Node start, Node end)
    {
        this.weight = weight;
        this.start = start;
        this.end = end;
    }
}

// this class will represent a node (vertex)
class Node
{
    // this will be the name of the node
    char name;
    // this will be the distance between this node and the origin node
    float distance;
    // this will be the predecessor of this node
    Node predecessor;
    // these will be the braches connected to this node
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
            // print a space and the name of the predecessor
            writeln(' ', this.predecessor.name);
        // else, meaning it doesn't have a predecessor
        else
            // just add a new line in the end
            writeln();
    }
}

// this will be the recursive function which will perform the DFS
void dfs(ref Node current, ref Node destination)
{
    // start a loop to check all branches of the current node
    foreach (ref edge; current.branches)
    {
        // if the distance of the adjacent node is bigger than it could be
        if (edge.end.distance > current.distance + edge.weight)
        {
            // reset the adjacent's distance to be that of the current node plus the weight of the branch
            edge.end.distance = current.distance + edge.weight;
            // reset the adjacent's predecessor to be the current node
            edge.end.predecessor = current;

            // if the adjacent vertex is not the destination
            if (edge.end != destination)
                // call the 'dfs()' function recursively on the adjacent node
                dfs(edge.end, destination);
        }
    }
}

// start the program with the main function
void main()
{
    // this string will contain the ordering with the result of the search
    string result;
    // this node will be the current node you are checking
    Node current;

    // create all the nodes with no distance and no predecessor, except the origin one which starts with distance = 0
    Node A = new Node('A', 0.0, null), B = new Node('B', float.infinity, null), C = new Node('C', float.infinity, null),
        D = new Node('D', float.infinity, null), E = new Node('E', float.infinity, null), F = new Node('F', float.infinity, null),
        G = new Node('G', float.infinity, null), H = new Node('H', float.infinity, null);

    // create all the branches which connect adjacent nodes
    Branch AtoB = Branch(1.0, A, B), AtoC = Branch(4.0, A, C),
        BtoA = Branch(1.0, B, A), BtoC = Branch(3.0, B, C), BtoD = Branch(1.0, B, D), BtoE = Branch(1.0, B, E), BtoG = Branch(3.0, B, G),
        CtoA = Branch(4.0, C, A), CtoB = Branch(3.0, C, B), CtoG = Branch(5.0, C, G),
        DtoB = Branch(1.0, D, B), DtoF = Branch(1.0, D, F), DtoG = Branch(2.0, D, G),
        EtoB = Branch(1.0, E, B), EtoG = Branch(2.0, A, B),
        FtoD = Branch(1.0, F, D), FtoG = Branch(2.0, F, G), FtoH = Branch(1.0, F, H),
        GtoB = Branch(3.0, G, B), GtoC = Branch(5.0, G, C), GtoD = Branch(2.0, G, D), GtoE = Branch(2.0, G, E), GtoF = Branch(2.0, G, F),
            GtoH = Branch(1.0, G, H),
        HtoF = Branch(1.0, H, F), HtoG = Branch(1.0, H, G);

    // assing each node its corresponding branches
    A.branches = [AtoB, AtoC], B.branches = [BtoA, BtoC, BtoD, BtoE, BtoG], C.branches = [CtoA, CtoB, CtoG], D.branches = [DtoB, DtoF, DtoG],
        E.branches = [EtoB, EtoG], F.branches = [FtoD, FtoG, FtoH], G.branches = [GtoB, GtoC, GtoD, GtoE, GtoF, GtoH], H.branches = [HtoF, HtoG];

    // call the 'dfs()' function on the origin node
    dfs(A, H);

    // start a loop to check the current node, starting with the destination node, and backtrack until it has found the ordering
    for (current = H; current !is null; current = current.predecessor)
        // add the name of the current node to the beginning of the result string
        result = current.name ~ result;

    // show result to the user (it should be a string with only capital letters in it, as in "ABCDFH")
    writeln(result);
    // show the data of each node to the user (it should be a string with the name, distance and predecessor of the node, as in "B 1 A")
    A.show(), B.show(), C.show(), D.show(), E.show(), F.show(), G.show(), H.show();
}
