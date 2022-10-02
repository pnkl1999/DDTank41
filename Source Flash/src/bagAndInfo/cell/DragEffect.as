package bagAndInfo.cell
{
   import ddt.interfaces.IAcceptDrag;
   import ddt.interfaces.IDragable;
   
   public class DragEffect
   {
      
      public static const NONE:String = "none";
      
      public static const MOVE:String = "move";
      
      public static const LINK:String = "link";
      
      public static const SPLIT:String = "split";
       
      
      public var source:IDragable;
      
      public var target:IAcceptDrag;
      
      public var action:String;
      
      public var data:*;
      
      public function DragEffect(param1:IDragable, param2:*, param3:String = "none", param4:IAcceptDrag = null)
      {
         super();
         this.source = param1;
         this.target = param4;
         this.action = param3;
         this.data = param2;
      }
      
      public function get hasAccpeted() : Boolean
      {
         return this.target != null;
      }
   }
}
