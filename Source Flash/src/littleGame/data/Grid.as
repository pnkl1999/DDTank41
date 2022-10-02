package littleGame.data
{
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   
   public class Grid implements Disposeable
   {
       
      
      public var type:int;
      
      public var cellSize:int = 7;
      
      private var _cols:int;
      
      private var _rows:int;
      
      private var _nodes:Array;
      
      private var _endNode:Node;
      
      private var _startNode:Node;
      
      private var _astar:AStar;
      
      private var _straightCost:Number = 1;
      
      private var _diagCost:Number = 1.41421;
      
      private var _width:int;
      
      private var _height:int;
      
      public function Grid(cols:int, rows:int)
      {
         this._nodes = new Array();
         super();
         this._cols = cols;
         this._rows = rows;
         this._width = this._rows * this.cellSize;
         this._height = this._cols * this.cellSize;
         this._astar = new AStar(this);
         this.creatGrid();
      }
      
      public function dispose() : void
      {
         var col:Node = null;
         var rows:Array = this._nodes.shift();
         while(rows != null)
         {
            col = rows.shift();
            while(col != null)
            {
               ObjectUtils.disposeObject(col);
               col = rows.shift();
            }
            rows = this._nodes.shift();
         }
         ObjectUtils.disposeObject(this._astar);
         this._astar = null;
      }
      
      public function get width() : int
      {
         return this._width;
      }
      
      public function get height() : int
      {
         return this._height;
      }
      
      public function get nodes() : Array
      {
         return this._nodes;
      }
      
      public function get path() : Array
      {
         return this._astar.path;
      }
      
      public function get endNode() : Node
      {
         return this._endNode;
      }
      
      public function get startNode() : Node
      {
         return this._startNode;
      }
      
      public function setEndNode(x:int, y:int) : void
      {
         if(this._nodes[y] != null)
         {
            this._endNode = this._nodes[y][x];
         }
      }
      
      public function setStartNode(x:int, y:int) : void
      {
         if(this._nodes[y] != null)
         {
            this._startNode = this._nodes[y][x];
         }
      }
      
      public function fillPath() : Boolean
      {
         return this._astar.fillPath();
      }
      
      private function creatGrid() : void
      {
         var column:Array = null;
         var j:int = 0;
         for(var i:int = 0; i < this._cols; i++)
         {
            column = new Array();
            for(j = 0; j < this._rows; j++)
            {
               column.push(new Node(j,i));
            }
            this._nodes.push(column);
         }
      }
      
      public function calculateLinks(type:int) : void
      {
         var j:int = 0;
         this.type = type;
         for(var i:int = 0; i < this._cols; i++)
         {
            for(j = 0; j < this._rows; j++)
            {
               this.initNodeLink(this._nodes[i][j],type);
            }
         }
      }
      
      public function getNode(x:int, y:int) : Node
      {
         var dy:int = Math.min(y,this._nodes.length - 1);
         dy = Math.max(0,dy);
         var dx:int = Math.min(x,this._nodes[0].length - 1);
         dx = Math.max(0,dx);
         return this._nodes[dy][dx];
      }
      
      public function setNodeWalkAble(x:int, y:int, walkable:Boolean) : void
      {
         if(this._nodes[y] && this._nodes[y][x])
         {
            this._nodes[y][x].walkable = walkable;
         }
      }
      
      private function clearNodeLink(node:Node) : void
      {
      }
      
      private function initNodeLink(node:Node, type:int) : void
      {
         var j:int = 0;
         var test:Node = null;
         var cost:Number = NaN;
         var test2:Node = null;
         var startX:int = Math.max(0,node.x - 1);
         var endX:int = Math.min(this._rows - 1,node.x + 1);
         var startY:int = Math.max(0,node.y - 1);
         var endY:int = Math.min(this._cols - 1,node.y + 1);
         node.links = [];
         for(var i:int = startX; i <= endX; i++)
         {
            for(j = startY; j <= endY; j++)
            {
               test = this.getNode(i,j);
               if(!(test == node || !test.walkable))
               {
                  if(type != 2 && i != node.x && j != node.y)
                  {
                     test2 = this.getNode(node.x,j);
                     if(!test2.walkable)
                     {
                        continue;
                     }
                     test2 = this.getNode(i,node.y);
                     if(!test2.walkable)
                     {
                        continue;
                     }
                  }
                  cost = this._straightCost;
                  if(!(node.x == test.x || node.y == test.y))
                  {
                     if(type == 1)
                     {
                        continue;
                     }
                     if(type == 2 && (node.x - test.x) * (node.y - test.y) == 1)
                     {
                        continue;
                     }
                     if(type == 2)
                     {
                        cost = this._straightCost;
                     }
                     else
                     {
                        cost = this._diagCost;
                     }
                  }
                  node.links.push(new Link(test,cost));
               }
            }
         }
      }
   }
}
