#include <iostream>
#include <stdlib.h>
#include <set>
#include <vector>
#include <fstream>
#include <string>
#include <algorithm>

using namespace std;

int n_nodes;

struct neighbors
{
  int x;
  int y;
};

void print_vector(vector<neighbors> v)
{
  for (int i = 0; i < v.size(); i++)  cout << v.at(i).x << " " << v.at(i).y;
  cout << endl;
}

void print_vector(vector<int> v)
{
  for (int i = 0; i < v.size(); i++)  cout << v.at(i) << " ";
  cout << endl;
}

class Parser
{
  public:
  int n;
  int c;
  int e;
  vector<neighbors> adjacent;

  public:
  Parser(string file);
};

Parser::Parser(string file)
{
  int tmp;
  int tmp2;
  neighbors couple;
  set<int> numberOfNodes; // avoid duplicates

  ifstream infile(file);
  if(infile.is_open())
  {
    infile >> e;
    while(!infile.eof())
    {
      infile >> tmp;
      tmp = tmp - 1;
      infile >> tmp2;
      tmp2 = tmp2 - 1;
      couple.x = tmp;
      couple.y = tmp2;
      adjacent.push_back(couple);
    }
    adjacent.pop_back(); //duplicate last element
  //  print_vector(adjacent);
  }
  infile.close();

  ifstream in(file);
  if(in.is_open())
  {
    in >> e;
    while(!in.eof())
    {
      in >> tmp;
      numberOfNodes.insert(tmp);
    }
  //  print_vector(adjacent);
  }

  n_nodes = numberOfNodes.size();
  cout << "Nodes " << n_nodes << endl;
  in.close();
}

class Node
{
  public:
  vector<char> conf;
  vector<Node> children;
  int score;
  int level;

  public:
  Node();
  Node(const Node& n);
};

Node::Node():level(0), conf(n_nodes, '*')
{}

Node::Node(const Node& n)
{
  conf = n.conf;
  this->level = n.level;
}


void print_configuration(Node& n)
{
  for(int i=0; i<n_nodes; i++) cout << n.conf[i] << " ";
  cout << endl;
}

void print_nodes(vector<Node> nodes)
{
  for (int i = 0; i < nodes.size(); i++)
  {
    print_configuration(nodes[i]);
    cout << endl;
  }
}

class Graph
{
  public:
  vector<vector<int> > adj;
  public:
  Graph(Parser parsed);
  vector<Node> generate_children(Node& n);
  bool isDoable(Node& n, int i);
  bool isLeaf (Node& n);
  bool areAdjacent(int node_1, int node_2);
  int getScore(Node& n);
  int maxScore(vector<Node> children);
  int minScore(vector<Node> children);
};

Graph::Graph(Parser parsed)
{
  int neighbor_1;
  int neighbor_2;
  adj.reserve(n_nodes);

  for (int i=0; i<parsed.adjacent.size(); i++)
  {
      neighbor_1 = parsed.adjacent[i].x;
      neighbor_2 = parsed.adjacent[i].y;
      adj[neighbor_1].push_back(neighbor_2);
      adj[neighbor_2].push_back(neighbor_1);
  }
}

bool Graph::areAdjacent(int node_1, int node_2)
{
  for (int i = 0; i < adj[node_1].size(); i++)
  {
    if (adj[node_1][i] == node_2) return true;
  }
  return false;
}


bool Graph::isDoable(Node& n, int action)
{
  vector<int> AMoves;
  vector<int> BMoves;
  int child_level = n.level;
  child_level++;

  //print_configuration(n);
  for (int i = 0; i<n_nodes; i++)
  {
    if (n.conf[i] == 'A') AMoves.push_back(i);
    if (n.conf[i] == 'B') BMoves.push_back(i);
  }

  if (child_level%2 == 1) //A move, the child is going to be an A node
  {
      for (int i = 0; i < AMoves.size(); i++)
      {
        if (areAdjacent(AMoves[i], action)) return false;
      }
  }

  else //B move, the child is going to be a B node
  {
    for (int i = 0; i < BMoves.size(); i++)
    {
      if (areAdjacent(BMoves[i], action)) return false;
    }
  }

  return true;
}

bool Graph::isLeaf (Node& n)
{
  vector<int> availableMoves;
  for (int i = 0; i<n_nodes; i++)
  {
    if (n.conf[i] == '*') availableMoves.push_back(i);
  }

  for (int i = 0; i < availableMoves.size(); i++)
  {
    if (isDoable(n, availableMoves[i])) return false;
  }

  return true;

}

vector<Node> Graph::generate_children(Node& n)
{
  vector<int> availableMoves;
  vector<Node> children;
  int child_level = n.level;
  child_level++;

  for (int i = 0; i<n_nodes; i++)
  {
    if (n.conf[i] == '*') availableMoves.push_back(i);
  }

  if (child_level%2 == 1) //A move
  {
    for (int i = 0; i < availableMoves.size(); i++)
    {
      if (isDoable(n, availableMoves[i]))
      {
        Node child(n);
        child.conf[availableMoves[i]] = 'A';
        child.level = child_level;
        children.push_back(child);
      }
    }
  }

  if (child_level%2 == 0)//B move
  {
    for (int i = 0; i < availableMoves.size(); i++)
    {
      if (isDoable(n, availableMoves[i]))
      {
        Node child(n);
        child.conf[availableMoves[i]] = 'B';
        child.level = child_level;
        children.push_back(child);
      }
    }
  }

  return children;
//  cout << n.children.size() << endl;
}

int Graph::maxScore(vector<Node> children)
{
  int max = -100000;
  int tmp = 0;
  for (int i = 0; i < children.size(); i++)
  {
    tmp = getScore(children[i]);
    if (tmp > max) max = tmp;
  }

  return max;
}

int Graph::minScore(vector<Node> children)
{
  int min = 100000;
  int tmp = 0;
  for (int i = 0; i < children.size(); i++)
  {
    tmp = getScore(children[i]);
    if (tmp < min)
    {
      min = tmp;
    }
  }

  return min;
}

int Graph::getScore(Node& n)
{
  int availableMoves = 0;

  for (int i = 0; i<n_nodes; i++)
  {
    if (n.conf[i] == '*') availableMoves++;
  }

  if(isLeaf(n))
  {
    if (n.level%2 == 1) //A leaf node
    {
      n.score = availableMoves;
    /*  print_configuration(n);
      cout << "Score " << n.score << endl;
      cout << "Level " << n.level << endl;*/
    }

    if (n.level%2 == 0) //B leaf node
    {
      n.score =  -1 * availableMoves;
  /*    print_configuration(n);
      cout << "Score l" << n.score << endl;
      cout << "Level l" << n.level << endl;*/
    }
  }

  else
  {
    if (n.level%2 == 1) //A node
    {
      n.children = generate_children(n);
      n.score = minScore(n.children);
    }

    if (n.level%2 == 0) //B node
    {
      n.children = generate_children(n);
      n.score = maxScore(n.children);
    }
  }

  return n.score;
}

int main()
{
  string file;
  cout << "Insert file name: ";
  cin >> file;
//  file = "test_lose.txt";
  ifstream in(file);
  if (!in.is_open()) cout << "Impossible to open the file " << endl;
  else
  {
    Parser parsed(file);
    Graph graph(parsed);
//    cout << "Nodes: " << n_nodes << endl;
    int max = -100000;
    int tmp = 0;
    int max_index;

    Node root;
    root.children = graph.generate_children(root);

    for (int i = 0; i < root.children.size(); i++)
    {
       tmp = graph.getScore(root.children[i]);
       int c = i;
       cout << "Node " << ++c << " score: " << tmp << endl;
       if (tmp > max)
       {
         max = tmp;
         max_index = i;
       }
     }

     if (max == 0) cout << "Tie" << endl;
     if (max < 0) cout << "A cannot win" << endl;
     if (max > 0) cout << "A wins coloring " << ++max_index << " first" << endl;
  }

  return 0;
}
