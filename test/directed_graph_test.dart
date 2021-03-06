import 'package:directed_graph/directed_graph.dart';
import 'package:test/test.dart';

/// To run the test, navigate to the folder 'directed_graph'
/// in your local copy of this library and use the command:
///
/// # pub run test -r expanded --test-randomize-ordering-seed=random
///
void main() {
  int comparator(
    Vertex<String> vertex1,
    Vertex<String> vertex2,
  ) {
    return vertex1.data.compareTo(vertex2.data);
  }

  int inverseComparator(
    Vertex<String> vertex1,
    Vertex<String> vertex2,
  ) {
    return -vertex1.data.compareTo(vertex2.data);
  }

  var a = Vertex<String>('a');
  var b = Vertex<String>('b');
  var c = Vertex<String>('c');
  var d = Vertex<String>('d');
  var e = Vertex<String>('e');
  var f = Vertex<String>('f');
  var g = Vertex<String>('g');
  var h = Vertex<String>('h');
  var i = Vertex<String>('i');
  var k = Vertex<String>('k');
  var l = Vertex<String>('l');

  var graph = DirectedGraph<String>(
    {
      a: [b, h, c, e],
      d: [e, f],
      b: [h],
      c: [h, g],
      f: [i],
      i: [l],
      k: [g, f]
    },
    comparator: comparator,
  );

  group('Basic:', () {
    test('toString().', () {
      expect(
          graph.toString(),
          '{\n'
          ' a: [b, h, c, e],\n'
          ' b: [h],\n'
          ' c: [h, g],\n'
          ' d: [e, f],\n'
          ' e: [],\n'
          ' f: [i],\n'
          ' g: [],\n'
          ' h: [],\n'
          ' i: [l],\n'
          ' k: [g, f],\n'
          ' l: [],\n'
          '}');
    });
    test('graph data', () {
      expect(graph.data, {
        'a': ['b', 'h', 'c', 'e'],
        'b': ['h'],
        'c': ['h', 'g'],
        'd': ['e', 'f'],
        'f': ['i'],
        'i': ['l'],
        'k': ['g', 'f']
      });
    });
    test('get comparator', () {
      expect(graph.comparator, comparator);
    });
    test('set comparator.', () {
      graph.comparator = inverseComparator;
      expect(graph.comparator, inverseComparator);
      expect(graph.vertices, [l, k, i, h, g, f, e, d, c, b, a]);
      graph.comparator = comparator;
    });
    test('for loop.', () {
      var index = 0;
      for (var vertex in graph) {
        expect(vertex, graph.vertices[index]);
        ++index;
      }
    });
    test('.fromData constructor.', () {
      final graphCopy = DirectedGraph<String>.fromData(
        {
          'a': ['b', 'h', 'c', 'e'],
          'b': ['h'],
          'c': ['h', 'g'],
          'd': ['e', 'f'],
          'e': [],
          'f': ['i'],
          'g': [],
          'h': [],
          'i': ['l'],
          'k': ['g', 'f'],
          'l': [],
        },
        comparator: comparator,
      );
      expect(
          graphCopy.toString(),
          '{\n'
          ' a: [b, h, c, e],\n'
          ' b: [h],\n'
          ' c: [h, g],\n'
          ' d: [e, f],\n'
          ' e: [],\n'
          ' f: [i],\n'
          ' g: [],\n'
          ' h: [],\n'
          ' i: [l],\n'
          ' k: [g, f],\n'
          ' l: [],\n'
          '}');
    });
  });
  group('Manipulating edges/vertices.', () {
    test('addEdges():', () {
      graph.addEdges(i, [k]);
      expect(graph.edges(i), [l, k]);
      '{\n'
          ' a: [b, h, c, e],\n'
          ' b: [h],\n'
          ' c: [h, g],\n'
          ' d: [e, f],\n'
          ' e: [],\n'
          ' f: [i],\n'
          ' g: [],\n'
          ' h: [],\n'
          ' i: [l],\n'
          ' k: [g, f],\n'
          ' l: [],\n'
          '}';
      graph.removeEdges(i, [k]);
      expect(graph.edges(i), [l]);
    });
    test('remove().', () {
      graph.remove(l);
      expect(graph.edges(i), []);
      expect(graph.vertices.contains(l), false);
      // Restore graph:
      graph.addEdges(i, [l]);
      expect(graph.vertices.contains(l), true);
      expect(graph.edges(i), [l]);
    });
  });
  group('Graph data:', () {
    test('edges().', () {
      expect(graph.edges(a), [b, h, c, e]);
    });
    test('indegree().', () {
      expect(graph.inDegree(h), 3);
    });
    test('indegree vertex with self-loop.', () {
      graph.addEdges(l, [l]);
      expect(graph.inDegree(l), 2);
      graph.removeEdges(l, [l]);
      expect(graph.inDegree(l), 1);
    });
    test('outDegree().', () {
      expect(graph.outDegree(d), 2);
    });
    test('outDegreeMap().', () {
      expect(graph.outDegreeMap,
          {a: 4, b: 1, c: 2, d: 2, e: 0, f: 1, g: 0, h: 0, i: 1, k: 2, l: 0});
    });
    test('inDegreeMap.', () {
      expect(graph.inDegreeMap,
          {a: 0, b: 1, h: 3, c: 1, e: 2, d: 0, f: 2, g: 2, i: 1, l: 1, k: 0});
    });
    test('vertices().', () {
      expect(graph.vertices, [a, b, c, d, e, f, g, h, i, k, l]);
    });
  });
  group('Topological ordering:', () {
    test('stronglyConnectedComponents().', () {
      expect(graph.stronglyConnectedComponents, [
        [h],
        [b],
        [g],
        [c],
        [e],
        [a],
        [l],
        [i],
        [f],
        [d],
        [k]
      ]);
    });
    test('shortestPath().', () {
      expect(graph.shortestPath(d, l), [f, i, l]);
    });

    test('isAcyclic(): self-loop.', () {
      graph.addEdges(l, [l]);
      expect(
        graph.isAcyclic,
        false,
      );
      graph.removeEdges(l, [l]);
    });
    test('isAcyclic(): without cycles', () {
      expect(graph.isAcyclic, true);
    });

    test('topologicalOrdering(): self-loop', () {
      graph.addEdges(l, [l]);
      expect(graph.topologicalOrdering, null);
      graph.removeEdges(l, [l]);
    });
    test('topologicalOrdering(): cycle', () {
      graph.addEdges(i, [k]);
      expect(graph.topologicalOrdering, null);
      graph.removeEdges(i, [k]);
    });
    test('sortedTopologicalOrdering():', () {
      expect(
          graph.sortedTopologicalOrdering, [a, b, c, d, e, h, k, f, g, i, l]);
    });
    test('topologicalOrdering():', () {
      expect(graph.topologicalOrdering, [a, b, c, d, e, h, k, f, i, g, l]);
    });
    test('topologicalOrdering(): empty graph', () {
      expect(DirectedGraph<int>({}).topologicalOrdering, []);
    });
    test('localSources().', () {
      expect(graph.localSources, [
        [a, d, k],
        [b, c, e, f],
        [g, h, i],
        [l]
      ]);
    });
  });
  group('Cycles', () {
    test('graph.cycle | acyclic graph.', () {
      expect(graph.cycle, []);
    });
    test('graph.findCycle() | acyclic graph.', () {
      expect(graph.findCycle(), []);
    });
    test('graph.cycle | cyclic graph.', () {
      graph.addEdges(l, [l]);
      expect(graph.cycle, [l, l]);
      graph.removeEdges(l, [l]);
    });
    test('graph.findCycle() | cyclic graph.', () {
      graph.addEdges(l, [l]);
      expect(graph.findCycle(), [l, l]);
      graph.removeEdges(l, [l]);
    });
    test('graph.cycle | non-trivial cycle.', () {
      graph.addEdges(i, [k]);
      expect(graph.cycle, [f, i, k, f]);
      graph.removeEdges(i, [k]);
    });
  });
}
