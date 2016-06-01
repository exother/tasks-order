# APP DEVELOPMENT PLAN

1. Initialize new app.
2. Analyze problem and set the suitable environment.
3. Create skeleton of the solution.
4. Add tests based on documentation.
5. Describe algorithm and implement it.
6. Make some refactor until all the tests don't pass.
7. Cover validation from the backend perspective.
8. Make some design based on Materialize and Angular (a little bit excess of form for this task but why not).
9. Add live validation from the frontend perspective.
10. Add predefining jobs section.
11. Require the main section to use only the predefined jobs.
12. Deploy the result to heroku.

# ALGORITHM DESCRIPTION

We build directed (acyclic) graph from the given structure and remember number of inner edges for all vertices.
Then, we initiate some queue and throw all the vertices with zero inner edges.
Getting vertices from the queue one by one, we go to their neighbours, decrement their amount of inner edges by 1 and when the amount is zero, we simply throw the vertex on the queue.
After visiting all the neighbours, we add the vertex at the end of the output collection.