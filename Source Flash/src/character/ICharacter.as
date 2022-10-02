package character
{
   import character.action.BaseAction;
   import flash.events.IEventDispatcher;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public interface ICharacter extends IEventDispatcher
   {
       
      
      function set label(param1:String) : void;
      
      function get label() : String;
      
      function hasAction(param1:String) : Boolean;
      
      function doAction(param1:String) : void;
      
      function addAction(param1:BaseAction) : void;
      
      function removeAction(param1:String) : void;
      
      function get itemWidth() : Number;
      
      function get itemHeight() : Number;
      
      function dispose() : void;
      
      function toXml() : XML;
      
      function get type() : int;
      
      function get actions() : Array;
      
      function get registerPoint() : Point;
      
      function get rect() : Rectangle;
      
      function getActionFrames(param1:String) : int;
      
      function set soundEnabled(param1:Boolean) : void;
      
      function get soundEnabled() : Boolean;
      
      function get realRender() : Boolean;
      
      function set realRender(param1:Boolean) : void;
   }
}
