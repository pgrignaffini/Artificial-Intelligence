To compile the code: g++ HW1.cpp -o HW1
To run: ./HW1

Function to calculate the successors state from a given node:

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

Following is presented the function that calculates the configuration if the blank is moved up, in a similar way are implemented all the other possible moves:

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

Function to check if the current configuration is a goal state:

bool check_goal(Node n, string goal)
{
  if (n.configuration.compare(goal) == 0) return true;
  return false;
}



