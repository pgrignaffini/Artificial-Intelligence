#include <iostream>
#include <stdlib.h>
#include <deque>
#include <queue>
#include <vector>
#include <fstream>
#include <string>

using namespace std;

class Parser
{
  public:
  int n;
  int c;
  int e;
  vector<int> adjacent;

  public:
  Parser(string file);

};

Parser::Parser(string file)
{
  int tmp;
  ifstream infile(file);
  if(infile.is_open())
  {
    infile >> n >> e >> c;
    while(!infile.eof())
    {
      infile >> tmp;
      tmp = tmp-1;
      adjacent.push_back(tmp);
    }
    adjacent.pop_back(); //duplicate last element
  }
  infile.close();
}

class Node
{
  public:
  vector<int> conf;
  vector<Node> children;
  int score;
  int level;
};

struct LessThanByF
{
  bool operator()(const Node& n1, const Node& n2) const
  {
    return n1.f_value > n2.f_value;
  }
};


class Graph
{
  private:
  int n_nodes;
  int n_colors;
  public:
  deque<Node> frontier;
  priority_queue<Node, vector<Node>, LessThanByF> frontier_Astar;
  deque<Node> children;
  vector<int> colors;
  vector< vector<int> > adj;

  public:
  Graph(Parser parsed);
  int h1(Node n);
  void generate_children(Node n);
  int check_goal(Node n);
  int get_nodes();
};

void print_vector(vector<int> v, int j)
{
  cout << j << " | ";
  for (int i=0; i<v.size(); i++)  cout << v[i] << " ";
  cout << endl;
}

void print_configuration(Node n)
{
  for(int i=0; i<n.conf.size(); i++) cout << n.conf[i] << " ";
  cout << endl;
}

int Graph::get_nodes()
{
  return n_nodes;
}

Graph::Graph(Parser parsed)
{
  n_nodes = parsed.n;
  n_colors = parsed.c;
  int index;
  for (int i=0; i<n_colors; i++) colors.push_back(i);
  adj.reserve(n_nodes);

  for (int i=0; i<parsed.adjacent.size(); i=i+2)
  {
      index = parsed.adjacent[i];
      adj[index].push_back(parsed.adjacent[i+1]);
  }

}

int Graph::check_goal(Node n)
{
  int size = n.conf.size();
  int color;

  if(size < n_nodes) return 0;
  if(size > n_nodes) return 2;
  for (int i=0; i<n.conf.size(); i++)
  {
    color = n.conf[i];
    if (adj[i].size() != 0) //check if it has neighbors
    {
      for (int j=0; j<adj[i].size(); j++)
      {
        if (color == n.conf[adj[i][j]]) return 0; //if it has the same color of some of its neighbors it can't be the solution
      }
    }
  }
  return 1;
}

void Graph::generate_children(Node n)
{
  children.clear();
  if (n.conf.size() >= n_nodes) return;
  for (int i=0; i<colors.size(); i++)
  {
    Node new_child = n;
    new_child.level = n.level + 1;
    new_child.conf.push_back(colors[i]);
    children.push_back(new_child);
  }
}

int Graph::h1(Node n) // calculate the number of constraints
{
  int h = 0;
  int value;
  int neighbor;
  int size = n.conf.size();
  int admissible_values[n_nodes][n_colors];

  for (int i = 0; i<size; i++)
  {
    for(int j=0; j<n_colors; j++) admissible_values[i][j] = 0;
  }

  for (int i = size; i<n_nodes; i++)
  {
    for(int j=0; j<n_colors; j++) admissible_values[i][j] = 1;
  }

  for (int i=0; i<size; i++)
  {
    value = n.conf[i]; //gets the color
    for (int j=0; j<adj[i].size(); j++)
    {
      neighbor = adj[i][j];// find the neighbor of the node
      admissible_values[neighbor][value] = 0;//the neighbor cannot have the same color, so it is set to 0
    }
  }

  for (int i=0; i<n_nodes; i++)
  {
    for(int j=0; j<n_colors; j++) h += admissible_values[i][j];
  }
  return h;
}

void BFS(string file)
{
  Parser parser(file);
  Graph graph(parser);
  int expanded_nodes=0;
  Node root;
  root.level = 0;
  graph.frontier.push_back(root);

  while (!graph.frontier.empty())
  {
    expanded_nodes++;
    Node current_state;
    current_state = graph.frontier.front();
    graph.frontier.pop_front();
  //  graph.explored.push_back(current_state);
    graph.generate_children(current_state);
    while (!graph.children.empty())
    {
      Node child;
      child = graph.children.front();
      graph.children.pop_front();

      if(graph.check_goal(child))
        {
          cout << "Goal reached: ";
          print_configuration(child);
          cout << "Expanded nodes: " << expanded_nodes << endl;
          cout << "Frontier size: " << graph.frontier.size() << endl;
          return;
        }
        graph.frontier.push_back(child);
      }
   }
   cout << "Impossible to find a solution" << endl;
}

void DFS(string file)
{
  Parser parser(file);
  Graph graph(parser);
  int expanded_nodes=0;
  Node root;
  root.level = 0;
  graph.frontier.push_back(root);

  while (!graph.frontier.empty())
  {
    expanded_nodes++;
    Node current_state = graph.frontier.back();
    if(graph.check_goal(current_state))
    {
      cout << "Goal reached: ";
      print_configuration(current_state);
      cout << "Expanded nodes: " << expanded_nodes << endl;
      cout << "Frontier size: " << graph.frontier.size() << endl;
      return;
    }
    graph.frontier.pop_back();
  //  graph.explored.push_back(current_state);
    graph.generate_children(current_state);
    int size = graph.children.size();
    for (int i=0; i<size; i++)
    {
      graph.frontier.push_back(graph.children.front());
      graph.children.pop_front();
    }
   }
   cout << "Impossible to find a solution" << endl;
}

bool IDE(Graph& graph, int limit)
{
  if (limit >= graph.get_nodes())
  {
    cout << "Impossible to find a solution" << endl;
    exit(0);
  }
  cout << "Limit: " << limit << endl;
  int expanded_nodes = 0;
  Node root;
  root.level = 0;
  graph.frontier.push_back(root);

	while (!graph.frontier.empty())
  {
		Node current = graph.frontier.back();
    graph.frontier.pop_back();
		expanded_nodes++;

			// Is solution
		if (graph.check_goal(current))
    {
      cout << "Goal reached: ";
      print_configuration(current);
      cout << "Expanded nodes: " << expanded_nodes << endl;
      cout << "Frontier size: " << graph.frontier.size() << endl;
			return true;
		}

			// Is not solution
		else
    {
			if (current.level <= limit)
      {
        graph.generate_children(current);
  			while (!graph.children.empty())
        {
          Node newNode = graph.children.front();
          graph.children.pop_front();
          graph.frontier.push_back(newNode);
  			 }
  		}
		 }

	}
  cout << "No solution found with limit: " << limit << endl;
	return false;
}


void Astar(string file)
{
  Parser parser(file);
  Graph graph(parser);
  Node root;
  root.level = 0;
  int expanded_nodes=0;
  graph.frontier_Astar.push(root);

  while (!graph.frontier_Astar.empty())
  {
  //  cout << "Frontier size: " << graph.frontier_Astar.size() << endl;
    expanded_nodes++;
    Node current_state = graph.frontier_Astar.top();
    //print_configuration(current_state);
    //cout << " G: " << current_state.g_value << " H: " << current_state.h_value << " F: " << current_state.f_value << endl;
    if(graph.check_goal(current_state))
    {
      cout << "Frontier size: " << graph.frontier_Astar.size() << endl;
      cout << "Goal reached: ";
      print_configuration(current_state);
      cout << "Expanded nodes: " << expanded_nodes << endl;
//      cout << current_state.configuration << " G: " << current_state.g_value << " H: " << current_state.h_value << " F: " << current_state.f_value << endl;
      return;
    }

    graph.frontier_Astar.pop();
//    graph.explored.push_back(current_state);
    graph.generate_children(current_state);
    int size = graph.children.size();
    for (int i=0; i<size; i++)
    {
      Node child = graph.children.front();
      child.g_value = child.level;
      child.h_value = graph.h1(child);
      child.f_value = child.g_value + child.h_value;
      //cout << child.configuration << " G: " << child.g_value << " H: " << child.h_value << " F: " << child.f_value << endl;
      graph.frontier_Astar.push(child);
      graph.children.pop_front();
    }
   }
   cout << "Impossible to find a solution" << endl;
}

int main()
{
  string file;
  int limit = 0;
  int choice;
  cout << "Insert file name: ";
  cin >> file;
  ifstream in(file);
  if (!in.is_open()) cout << "Impossible to open the file " << endl;
  else
  {
    cout << endl;
    cout << "Choose which algorithm use: " << endl;
    cout << "\t1. BFS" << endl;
    cout << "\t2. DFS" << endl;
    cout << "\t3. A*" << endl;
    cout << "\t4. IDE" << endl;
    cout << "Insert your choice: ";
    cin >> choice;

    switch(choice)
    {
      case 1: BFS(file);
      break;
      case 2: DFS(file);
      break;
      case 3: Astar(file);
      break;
      case 4:
      {
        Parser parsed(file);
        Graph graph(parsed);
        while(!IDE(graph, limit))
        {
          graph.frontier.clear();
          graph.children.clear();
          ++limit;
        }
      }
      break;
      default: cout <<"Option not available"<<endl;
    }
   }
  return 0;
}
