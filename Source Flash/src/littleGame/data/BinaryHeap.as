package littleGame.data
{
   public class BinaryHeap
   {
       
      
      public var a:Array;
      
      private var _justMinFunc:Function;
      
      public function BinaryHeap(justMinFunc:Function)
      {
         this.a = new Array();
         super();
         this.a.push(-1);
         this._justMinFunc = justMinFunc;
      }
      
      public function ins(node:Node) : void
      {
         var temp:Object = null;
         var p:int = this.a.length;
         this.a[p] = node;
         var parent:int = p >> 1;
         while(p > 1 && this._justMinFunc(this.a[p],this.a[parent]))
         {
            temp = this.a[p];
            this.a[p] = this.a[parent];
            this.a[parent] = temp;
            p = parent;
            parent = p >> 1;
         }
      }
      
      public function pop() : Node
      {
         var minp:int = 0;
         var temp:Object = null;
         var min:Object = this.a[1];
         this.a[1] = this.a[this.a.length - 1];
         this.a.pop();
         var p:int = 1;
         var l:int = this.a.length;
         var child1:int = p << 1;
         var child2:int = child1 + 1;
         while(child1 < l)
         {
            if(child2 < l)
            {
               minp = !!Boolean(this._justMinFunc(this.a[child2],this.a[child1])) ? int(int(child2)) : int(int(child1));
            }
            else
            {
               minp = child1;
            }
            if(!this._justMinFunc(this.a[minp],this.a[p]))
            {
               break;
            }
            temp = this.a[p];
            this.a[p] = this.a[minp];
            this.a[minp] = temp;
            p = minp;
            child1 = p << 1;
            child2 = child1 + 1;
         }
         return min as Node;
      }
   }
}
