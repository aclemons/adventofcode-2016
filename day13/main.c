// MIT License
//
// Copyright (c) 2016 Andrew Clemons
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#include <stdio.h>
#include <stdlib.h>

static const int WALL = 1;

static const unsigned int TARGET_X = 31;
static const unsigned int TARGET_Y = 39;

static const unsigned int INITIAL_X = 1;
static const unsigned int INITIAL_Y = 1;

typedef struct coordinate_t {
  unsigned int distance;
  unsigned int x;
  unsigned int y;
  struct coordinate_t *parent;
} coordinate_t;

typedef struct Node {
  coordinate_t *data;
  struct Node *next;
} node_t;

/* example from Kernighan and Ritchie - The C Programming Language */
int bit_count(unsigned int value) {
  unsigned int count = 0;

  for (; value > 0; value = value & (value - 1)) {
    count++;
  }

  return count;
}

int coordinate_type(const unsigned int x, const unsigned int y,
                    const unsigned int favourite_number) {
  const unsigned int result = (x * x) + (3 * x) + (2 * x * y) + y + (y * y);
  const unsigned int sum = result + favourite_number;

  return bit_count(sum) % 2;
}

void push(node_t **head, coordinate_t *node) {
  if (*head != NULL && (*head)->next != NULL) {
    return push(&((*head)->next), node);
  }

  node_t *end = malloc(sizeof(node_t));
  if (!end) {
    perror("malloc failed!");
    exit(1);
  }

  end->data = node;
  end->next = NULL;

  if (*head == NULL) {
    *head = end;
  } else {
    (*head)->next = end;
  }
}

coordinate_t *pop(node_t **head) {
  coordinate_t *retval = NULL;
  node_t *next_node = NULL;

  if (*head == NULL) {
    return NULL;
  }

  next_node = (*head)->next;
  retval = (*head)->data;
  free(*head);
  *head = next_node;

  return retval;
}
coordinate_t *allocate_coordinate(const unsigned int x, const unsigned int y) {
  coordinate_t *node = malloc(sizeof(coordinate_t));

  if (node == NULL) {
    perror("malloc failed!");
    exit(1);
  }

  node->x = x;
  node->y = y;
  node->distance = 0;
  node->parent = NULL;

  return node;
}

void shortest_path(const unsigned int favourite) {
  unsigned int x_length = 500;
  unsigned int y_length = 500;

  coordinate_t ***grid;

  grid = (coordinate_t ***)calloc(x_length, sizeof(**grid));
  if (!grid) {
    perror("calloc failed!");

    exit(1);
  }

  for (unsigned int i = 0; i < x_length; i++) {
    grid[i] = (coordinate_t **)calloc(y_length, sizeof(coordinate_t *));

    if (!grid[i]) {
      perror("calloc failed!");

      exit(1);
    }

    for (unsigned int j = 0; j < y_length; j++) {
      grid[i][j] = NULL;
    }
  }

  coordinate_t *initial_position = allocate_coordinate(INITIAL_X, INITIAL_Y);
  grid[INITIAL_X][INITIAL_Y] = initial_position;

  node_t *queue;

  queue = malloc(sizeof(node_t));
  if (!queue) {
    perror("malloc failed!");

    exit(1);
  }

  queue->data = initial_position;
  queue->next = NULL;

  const int offsets[4][2] = {
      {1, 0}, {-1, 0}, {0, 1}, {0, -1},
  };

  unsigned int seen_nodes = 1;

  while (queue != NULL) {
    coordinate_t *current = pop(&queue);

    for (int i = 0; i < 4; i++) {
      if (current->x == 0 && offsets[i][0] == -1) {
        continue;
      }

      if (current->y == 0 && offsets[i][1] == -1) {
        continue;
      }

      unsigned int new_x = current->x + offsets[i][0];
      unsigned int new_y = current->y + offsets[i][1];

      if (coordinate_type(new_x, new_y, favourite) == WALL) {
        continue;
      }

      if (grid[new_x][new_y] == NULL) {
        coordinate_t *adjacent_node = allocate_coordinate(new_x, new_y);
        grid[new_x][new_y] = adjacent_node;

        adjacent_node->distance = current->distance + 1;
        adjacent_node->parent = current;

        push(&queue, adjacent_node);

        if (adjacent_node->distance <= 50) {
          seen_nodes += 1;
        }

        if (new_x == TARGET_X && new_y == TARGET_Y) {
          printf(
              "The fewest number of steps required for you to reach (%d, %d) "
              "is %d\n",
              TARGET_X, TARGET_Y, adjacent_node->distance);

          printf("%d locations can be reachead in at most 50 steps\n",
                 seen_nodes);

          break;
        }
      }
    }
  }

  // free the rest of the queue
  while (queue != NULL) {
    pop(&queue);
  }

  unsigned int x = 0;
  unsigned int y = 0;

  for (; x < x_length; x++) {
    for (; y < y_length; y++) {
      if (grid[x][y] != NULL) {
        free(grid[x][y]);
      }
    }

    free(grid[x]);
  }

  free(grid);
}

int main(void) {
  unsigned int favourite;
  const int read = scanf("%d", &favourite);

  if (read == EOF || read == 0) {
    printf("input?\n");

    return 1;
  }

  shortest_path(favourite);

  return 0;
}
