package littleGame.data
{
   import com.pickgliss.ui.core.Disposeable;
   import flash.geom.Point;
   import flash.utils.getTimer;
   
   public class AStar implements Disposeable
   {
       
      
      public var heuristic:Function;
      
      private var _straightCost:Number = 1;
      
      private var _diagCost:Number = 1.41421;
      
      private var nowversion:int = 0;
      
      private var TwoOneTwoZero:Number;
      
      private var _endNode:Node;
      
      private var _startNode:Node;
      
      private var _grid:Grid;
      
      private var _open:BinaryHeap;
      
      private var _path:Array;
      
      private var _floydPath:Array;
      
      public function AStar(grid:Grid)
      {
         this.TwoOneTwoZero = 2 * Math.cos(Math.PI / 3);
         super();
         this._grid = grid;
         this.heuristic = this.euclidian2;
      }
      
      public function dispose() : void
      {
         this._open = null;
         this.heuristic = null;
         this._startNode = null;
         this._endNode = null;
         this._grid = null;
         this._path = null;
      }
      
      private function justMin(node1:Node, node2:Node) : Boolean
      {
         return node1.f < node2.f;
      }
      
      public function manhattan(node:Node) : Number
      {
         return Math.abs(node.x - this._endNode.x) + Math.abs(node.y - this._endNode.y);
      }
      
      public function manhattan2(node:Node) : Number
      {
         var dx:Number = Math.abs(node.x - this._endNode.x);
         var dy:Number = Math.abs(node.y - this._endNode.y);
         return dx + dy + Math.abs(dx - dy) / 1000;
      }
      
      public function euclidian(node:Node) : Number
      {
         var dx:Number = node.x - this._endNode.x;
         var dy:Number = node.y - this._endNode.y;
         return Math.sqrt(dx * dx + dy * dy);
      }
      
      public function chineseCheckersEuclidian2(node:Node) : Number
      {
         var x:Number = node.y / this.TwoOneTwoZero;
         var y:Number = node.x + node.y / 2;
         var dx:Number = y - this._endNode.x - this._endNode.y / 2;
         var dy:Number = x - this._endNode.y / this.TwoOneTwoZero;
         return this.sqrt(dx * dx + dy * dy);
      }
      
      private function sqrt(x:Number) : Number
      {
         return Math.sqrt(x);
      }
      
      public function euclidian2(node:Node) : Number
      {
         var dx:Number = node.x - this._endNode.x;
         var dy:Number = node.y - this._endNode.y;
         return dx * dx + dy * dy;
      }
      
      public function fillPath() : Boolean
      {
         this._endNode = this._grid.endNode;
         this._startNode = this._grid.startNode;
         ++this.nowversion;
         this._open = new BinaryHeap(this.justMin);
         this._startNode.g = 0;
         var time:int = getTimer();
         return Boolean(this.search());
      }
      
      public function search() : Boolean
      {
         var len:int = 0;
         var i:int = 0;
         var test:Node = null;
         var cost:Number = NaN;
         var g:Number = NaN;
         var h:Number = NaN;
         var f:Number = NaN;
         var node:Node = this._startNode;
         node.version = this.nowversion;
         while(node != this._endNode)
         {
            len = node.links.length;
            for(i = 0; i < len; i++)
            {
               test = node.links[i].node;
               cost = node.links[i].cost;
               g = node.g + cost;
               h = this.heuristic(test);
               f = g + h;
               if(test.version == this.nowversion)
               {
                  if(test.f > f)
                  {
                     test.f = f;
                     test.g = g;
                     test.h = h;
                     test.parent = node;
                  }
               }
               else
               {
                  test.f = f;
                  test.g = g;
                  test.h = h;
                  test.parent = node;
                  this._open.ins(test);
                  test.version = this.nowversion;
               }
            }
            if(this._open.a.length == 1)
            {
               return false;
            }
            node = this._open.pop() as Node;
         }
         this.buildPath();
         return true;
      }
      
      private function buildPath() : void
      {
         this._path = [];
         var current:Node = this._endNode;
         this._path.push(current);
         while(current != this._startNode)
         {
            current = current.parent;
            this._path.unshift(current);
         }
      }
      
      public function get path() : Array
      {
         return this._path;
      }
      
      public function floyd() : void
      {
         var vector:Node = null;
         var tempVector:Node = null;
         var i:int = 0;
         var j:int = 0;
         var k:int = 0;
         if(this.path == null)
         {
            return;
         }
         this._floydPath = this.path.concat();
         var len:int = this._floydPath.length;
         if(len > 2)
         {
            vector = new Node(0,0);
            tempVector = new Node(0,0);
            this.floydVector(vector,this._floydPath[len - 1],this._floydPath[len - 2]);
            for(i = this._floydPath.length - 3; i >= 0; i--)
            {
               this.floydVector(tempVector,this._floydPath[i + 1],this._floydPath[i]);
               if(vector.x == tempVector.x && vector.y == tempVector.y)
               {
                  this._floydPath.splice(i + 1,1);
               }
               else
               {
                  vector.x = tempVector.x;
                  vector.y = tempVector.y;
               }
            }
         }
         len = this._floydPath.length;
         for(i = len - 1; i >= 0; i--)
         {
            for(j = 0; j <= i - 2; j++)
            {
               if(this.floydCrossAble(this._floydPath[i],this._floydPath[j]))
               {
                  for(k = i - 1; k > j; k--)
                  {
                     this._floydPath.splice(k,1);
                  }
                  i = j;
                  len = this._floydPath.length;
                  break;
               }
            }
         }
      }
      
      private function floydCrossAble(n1:Node, n2:Node) : Boolean
      {
         var ps:Array = this.bresenhamNodes(new Point(n1.x,n1.y),new Point(n2.x,n2.y));
         for(var i:int = ps.length - 2; i > 0; i--)
         {
            if(!this._grid.getNode(ps[i].x,ps[i].y).walkable)
            {
               return false;
            }
         }
         return true;
      }
      
      private function floydVector(target:Node, n1:Node, n2:Node) : void
      {
         target.x = n1.x - n2.x;
         target.y = n1.y - n2.y;
      }
      
      private function bresenhamNodes(p1:Point, p2:Point) : Array
      {
         var temp:int = 0;
         var fy:int = 0;
         var cy:int = 0;
         var steep:Boolean = Math.abs(p2.y - p1.y) > Math.abs(p2.x - p1.x);
         if(steep)
         {
            temp = p1.x;
            p1.x = p1.y;
            p1.y = temp;
            temp = p2.x;
            p2.x = p2.y;
            p2.y = temp;
         }
         var stepX:int = p2.x > p1.x ? int(int(1)) : (p2.x < p1.x ? int(int(-1)) : int(int(0)));
         var stepY:int = p2.y > p1.y ? int(int(1)) : (p2.y < p1.y ? int(int(-1)) : int(int(0)));
         var deltay:Number = (p2.y - p1.y) / Math.abs(p2.x - p1.x);
         var ret:Array = [];
         var nowX:Number = p1.x + stepX;
         var nowY:Number = p1.y + deltay;
         if(steep)
         {
            ret.push(new Point(p1.y,p1.x));
         }
         else
         {
            ret.push(new Point(p1.x,p1.y));
         }
         while(nowX != p2.x)
         {
            fy = Math.floor(nowY);
            cy = Math.ceil(nowY);
            if(steep)
            {
               ret.push(new Point(fy,nowX));
            }
            else
            {
               ret.push(new Point(nowX,fy));
            }
            if(fy != cy)
            {
               if(steep)
               {
                  ret.push(new Point(cy,nowX));
               }
               else
               {
                  ret.push(new Point(nowX,cy));
               }
            }
            nowX += stepX;
            nowY += deltay;
         }
         if(steep)
         {
            ret.push(new Point(p2.y,p2.x));
         }
         else
         {
            ret.push(new Point(p2.x,p2.y));
         }
         return ret;
      }
      
      public function get floydPath() : Array
      {
         return this._floydPath;
      }
   }
}
