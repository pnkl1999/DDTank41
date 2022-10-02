package littleGame.data
{
	public class Link
   {
       
      
      public var node:Node;
      
      public var cost:Number;
      
      function Link(node:Node, cost:Number)
      {
         super();
         this.node = node;
         this.cost = cost;
      }
   }
}
