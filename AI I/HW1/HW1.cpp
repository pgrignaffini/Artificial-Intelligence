#include <iostream>
#include <stdlib.h>
#include <deque>
#include <queue>
#include <vector>

using namespace std;

struct int2
{
  int x;
  int y;
};

class Node
{
  public:
  string configuration;
  int h_value;
  int g_value;
  int f_value;
  int level;
  public:
    Node create_node(string conf);
    int find_tile(Node n, char tile);
    int move_up (Node n);
    int move_down (Node n);
    int move_left (Node n);
    int move_right (Node n);
    int get_level();
};

int get_level(Node n)
{
  return n.level;
}

int find_tile(Node n, char tile)
{
  for (int i=0; i<n.configuration.length(); i++)
    if (tile == n.configuration[i]) return i;

  cout<<"Tile doesn't exist"<< endl;
  return -1;
}

int move_up (Node& n)
{
  int index = find_tile(n,'*');
  if (index < 0) return 0;

  if (index <= 2)
  {
    cout << "Impossible to move up a tile in the high border" << endl;
    return 0;
  }

  cout<< "Expanding node: |" << n.configuration << "|";
  n.configuration[index] = n.configuration[index-3];
  n.configuration[index-3] = '*';
  cout << " Move up => new configuration: " << n.configuration << endl;
  return 1;
}

int move_down(Node& n)
{
  int index = find_tile(n,'*');
  if (index < 0) return 0;

  if (index >= 5)
  {
    cout << "Impossible to move down a tile in the low border" << endl;
    return 0;
  }

    cout<< "Expanding node: |" << n.configuration << "|";
    n.configuration[index] = n.configuration[index+3];
    n.configuration[index+3] = '*';
    cout << " Move down => new configuration: " << n.configuration << endl;
    return 1;

}

int move_left (Node& n)
{
  int index = find_tile(n,'*');
  if (index < 0) return 0;

  if (index == 0 || index == 3 || index == 6)
  {
    cout << "Impossible to move left a tile in the left border" << endl;
    return 0;
  }

  cout<< "Expanding node: |" << n.configuration << "|";
  n.configuration[index] = n.configuration[index-1];
  n.configuration[index-1] = '*';
  cout << " Move left => new configuration: " << n.configuration << endl;
  return 1;
}

int move_right (Node& n)
{
  int index = find_tile(n,'*');
  if (index < 0) return 0;

  if (index == 2 || index == 5 || index == 8)
  {
    cout << "Impossible to move right a tile in the right border" << endl;
    cout << "--------------------------------------------------------------------" << endl;
    return 0;
  }

  cout<< "Expanding node: |" << n.configuration << "|";;
  n.configuration[index] = n.configuration[index+1];
  n.configuration[index+1] = '*';
  cout << " Move right => new configuration: " << n.configuration << endl;
  cout << "--------------------------------------------------------------------" << endl;
  return 1;
}

Node create_node(string conf)
{
  Node new_node;
  new_node.configuration = conf;
  return new_node;
}

struct LessThanByF
{
  bool operator()(const Node& n1, const Node& n2) const
  {
    return n1.f_value > n2.f_value;
  }
};

class Graph
{
  public:
  deque<Node> frontier;
  priority_queue<Node, vector<Node>, LessThanByF> frontier_Astar;
  deque<Node> explored;
  deque<Node> children;
  public:
  void BFS(string problem);
  bool check_explored(Node n);
  bool check_frontier(Node n);
  void print_queue (deque<Node> qu);
  void print_configuration (string conf);
  deque<Node> generate_children(Node n);
  bool check_goal(Node n, string goal);
  int get_depth();
};

deque<Node> generate_children(Node n)
{
  deque<Node> children;
  Node new_child = n;

  if (move_up(new_child)) children.push_back(new_child);
  new_child = n;
  if (move_down(new_child)) children.push_back(new_child);
  new_child = n;
  if (move_left(new_child)) children.push_back(new_child);
  new_child = n;
  if (move_right(new_child)) children.push_back(new_child);

  return children;
}

bool check_goal(Node n, string goal)
{
  if (n.configuration.compare(goal) == 0) return true;
  return false;
}

bool check_explored(Node n, deque<Node> explored)
{
  int size = explored.size();
  for (int i=0; i<size; i++)
      if (n.configuration.compare(explored[i].configuration)==0) return true;

  return false;
}

bool check_frontier(Node n, deque<Node> frontier)
{
  int size = frontier.size();
  for (int i=0; i<size; i++)
      if (n.configuration.compare(frontier[i].configuration)==0) return true;
  return false;
}

void print_queue (deque<Node> qu)
{
  int size = qu.size();
  for (int i=0; i<size; i++)
    {
      cout << "|" << qu.front().configuration << "|";
      qu.pop_front();
    }
}

void print_configuration (string conf)
{
  cout << " + - - - + " << endl;
  cout << " |" << conf[0] << "  " << conf[1] << "  " << conf[2] << "|" << endl;
  cout << " |" << conf[3] << "  " << conf[4] << "  " << conf[5] << "|" << endl;
  cout << " |" << conf[6] << "  " << conf[7] << "  " << conf[8] << "|" <<endl;
  cout << " + - - - + " << endl;
}

void BFS(Graph graph, Node problem, string goal)
{
  int expanded_nodes=0;
  if(check_goal(problem, goal)) return;
  graph.frontier.push_back(problem);

  while (!graph.frontier.empty())
  {
    expanded_nodes++;
    Node current_state;
    current_state = graph.frontier.front();
    graph.frontier.pop_front();
    graph.explored.push_back(current_state);
    print_configuration(current_state.configuration);
    graph.children = generate_children(current_state);
    cout << "Children: ";
    print_queue(graph.children);
    cout << endl;
    while (!graph.children.empty())
    {
      Node child;
      child = graph.children.front();
      cout << "Checking: " << child.configuration << endl;
      graph.children.pop_front();
      if (!check_explored(child, graph.explored) && !check_frontier(child, graph.frontier))
      {
        if(check_goal(child, goal))
        {
          cout << "Goal reached: " << child.configuration << endl;
          print_configuration(child.configuration);
          cout << "Expanded nodes: " << expanded_nodes << endl;
          cout << "Frontier size: " << graph.frontier.size() << endl;
          return;
        }
        graph.frontier.push_back(child);
      }
      cout << "Frontier size: " << graph.frontier.size() << endl;
    }
  }
}

void DFS(Graph graph, Node problem, string goal)
{
  cout << "Frontier size: " << graph.frontier.size() << endl;
  int expanded_nodes=0;

  graph.frontier.push_back(problem);

  while (!graph.frontier.empty())
  {
    expanded_nodes++;
    Node current_state = graph.frontier.back();
    if(check_goal(current_state, goal))
    {
      cout << "Goal reached: " << current_state.configuration << endl;
      print_configuration(current_state.configuration);
      cout << "Expanded nodes: " << expanded_nodes << endl;
      cout << "Frontier size: " << graph.frontier.size() << endl;
      return;
    }
    graph.frontier.pop_back();
    graph.explored.push_back(current_state);
    graph.children = generate_children(current_state);
    int size = graph.children.size();
    for (int i=0; i<size; i++)
    {
      if(!check_explored(graph.children.front(), graph.explored)) graph.frontier.push_back(graph.children.front());
        graph.children.pop_front();
    }
   }
}

deque<Node>  set_level (deque<Node> qu, int lev)
{
  for (int i=0; i<qu.size(); i++)
    qu[i].level = lev;

  return qu;
}

void add2deque (deque<Node> adding ,deque<Node> toadd)
{
    for (int i=0; i<toadd.size(); i++)
      adding.push_back(toadd[i]);
}


bool IDE(Graph graph, Node problem, string goal, int limit)
{
  cout << "Limit: " << limit << endl;
  int expanded_nodes = 0;
  graph.frontier.clear();
  graph.explored.clear();

  problem.level = 0;
  graph.frontier.push_back(problem);
  graph.explored.push_back(problem);

	while (!graph.frontier.empty()) {

			Node current = graph.frontier.back();
      graph.frontier.pop_back();
			expanded_nodes++;

			// Is solution
			if (check_goal(current, goal)) {
        cout << "Goal reached: " << current.configuration << endl;
        print_configuration(current.configuration);
        cout << "Expanded nodes: " << expanded_nodes << endl;
        cout << "Frontier size: " << graph.frontier.size() << endl;
        cout << "Level: " << current.level << endl;
				return true;
			}

			// Is not solution
			else {
				if (current.level <= limit) {
          graph.children = generate_children(current);
          print_queue(graph.children);
          cout << endl;
					while (!graph.children.empty())
          {
            Node newNode = graph.children.front();
            graph.children.pop_front();
            newNode.level = current.level + 1;
            if(!check_explored(newNode, graph.explored))
            {
              cout << "Adding " << newNode.configuration << endl;
              graph.frontier.push_back(newNode);
              graph.explored.push_back(newNode);
            }
            else
            {
              cout << newNode.configuration << "already present" << endl;
            }
            cout << "Frontier" ;
            print_queue(graph.frontier);
            cout << endl;
				  }
			}
		}

	}
  cout << "No solution found with limit: " << limit << endl;
	return false;
}

int h1(Node n, string goal)
{
  int misplaced_tiles=0;
  for (int i=0; i<goal.size(); i++)
  {
    if (n.configuration[i]!=goal[i]) misplaced_tiles++;
  }
  return misplaced_tiles;
}

int h2(Node n, string goal)
{
  int manhattan_distance=0;

  for (int i=0; i<9; i++)
  {
    for(int j=0; j<9; j++)
      if (n.configuration[i] == goal[j]) manhattan_distance += (abs(i/3 - j/3) + abs(i%3 - j%3));
  }

  return manhattan_distance;
}

void Astar(Graph graph, Node problem, string goal)
{
  int expanded_nodes=0;
  int lev = 0;
  problem.level = lev;
  graph.frontier_Astar.push(problem);

  while (!graph.frontier_Astar.empty())
  {
    cout << "Frontier size: " << graph.frontier_Astar.size() << endl;
    expanded_nodes++;
    Node current_state = graph.frontier_Astar.top();
    if(check_goal(current_state, goal))
    {
      cout << "Frontier size: " << graph.frontier_Astar.size() << endl;
      cout << "Goal reached: " << current_state.configuration << endl;
      print_configuration(current_state.configuration);
      cout << "Expanded nodes: " << expanded_nodes << endl;
      cout << current_state.configuration << " G: " << current_state.g_value << " H: " << current_state.h_value << " F: " << current_state.f_value << endl;
      return;
    }

    graph.frontier_Astar.pop();
    graph.explored.push_back(current_state);
    graph.children = generate_children(current_state);
    graph.children = set_level(graph.children, current_state.level+1);
    int size = graph.children.size();
    for (int i=0; i<size; i++)
    {
      Node child = graph.children.front();

      if(!check_explored(child, graph.explored))
      {
        child.g_value = child.level;
        child.h_value = h1(child, goal);
        child.f_value = child.g_value + child.h_value;
        cout << child.configuration << " G: " << child.g_value << " H: " << child.h_value << " F: " << child.f_value << endl;
        graph.frontier_Astar.push(child);
      }

      graph.children.pop_front();
    }
   }
}

void Astar_manhattan(Graph graph, Node problem, string goal)
{
  int expanded_nodes=0;
  int lev = 0;
  problem.level = lev;
  graph.frontier_Astar.push(problem);

  while (!graph.frontier_Astar.empty())
  {
    cout << "Frontier size: " << graph.frontier_Astar.size() << endl;
    expanded_nodes++;
    Node current_state = graph.frontier_Astar.top();
    if(check_goal(current_state, goal))
    {
      cout << "Frontier size: " << graph.frontier_Astar.size() << endl;
      cout << "Goal reached: " << current_state.configuration << endl;
      print_configuration(current_state.configuration);
      cout << "Expanded nodes: " << expanded_nodes << endl;
      cout << current_state.configuration << " G: " << current_state.g_value << " H: " << current_state.h_value << " F: " << current_state.f_value << endl;
      return;
    }

    graph.frontier_Astar.pop();
    graph.explored.push_back(current_state);
    graph.children = generate_children(current_state);
    graph.children = set_level(graph.children, current_state.level+1);
    int size = graph.children.size();
    for (int i=0; i<size; i++)
    {
      Node child = graph.children.front();

      if(!check_explored(child, graph.explored))
      {
        child.g_value = child.level;
        child.h_value = h2(child, goal);
        child.f_value = child.g_value + child.h_value;
        cout << child.configuration << " G: " << child.g_value << " H: " << child.h_value << " F: " << child.f_value << endl;
        graph.frontier_Astar.push(child);
      }

      graph.children.pop_front();
    }
   }
}

int main(int argc, char const *argv[]) {

  Graph graph;
  string problem;
  string goal;
  Node root;
  int choice;
  int limit=0;

  while (true)
  {
    cout << "Insert problem configuration: ";
    cin >> problem;
    if (problem.size()!=9) cout << "Problem configuration must be exactly 9 characters!!" << endl;
    else break;
  }

  root = create_node(problem);

  while (true)
  {
    cout << "Insert goal configuration: ";
    cin >> goal;
    if (goal.size()!=9) cout << "Goal configuration must be exactly 9 characters!!" << endl;
    else break;
  }

  cout << "Problem configuration: " << problem << endl;
  cout << "Goal configuration: " << goal << endl;

  while (true)
  {
    cout << "Choose which algorithm use: " << endl;
    cout << "\t1. BFS" << endl;
    cout << "\t2. DFS" << endl;
    cout << "\t3. A* (misplaced tiles)" << endl;
    cout << "\t4. A* (manhattan distance)" << endl;
    cout << "\t5. IDE" << endl;
    cout << "\t6. Exit" << endl;

    cout << "Insert your choice: ";
    cin >> choice;

    switch(choice)
    {
      case 1: BFS(graph, root, goal);
      break;
      case 2: DFS(graph, root, goal);
      break;
      case 3: Astar(graph, root, goal);
      break;
      case 4: Astar_manhattan(graph, root, goal);
      break;
      case 5:
      while(!IDE(graph, root, goal, limit))
      {
        ++limit;
      }
      break;
      case 6: return 0;
      default: cout <<"Option not available"<<endl;
    }
  }

  return 0;
}

//281*43765 Problem
//1238*4765 goal
