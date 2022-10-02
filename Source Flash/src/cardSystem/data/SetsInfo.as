package cardSystem.data
{
   import flash.events.EventDispatcher;
   
   public class SetsInfo extends EventDispatcher
   {
       
      
      public var ID:String;
      
      public var name:String;
      
      public var cardIdVec:Vector.<int>;
      
      public var storyDescript:String;
      
      public function SetsInfo()
      {
         super();
         this.cardIdVec = new Vector.<int>();
      }
   }
}
