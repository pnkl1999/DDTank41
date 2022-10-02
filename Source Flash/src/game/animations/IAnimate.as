package game.animations
{
   import game.view.map.MapView;
   
   public interface IAnimate
   {
       
      
      function get level() : int;
      
      function prepare(param1:AnimationSet) : void;
      
      function canAct() : Boolean;
      
      function update(param1:MapView) : Boolean;
      
      function canReplace(param1:IAnimate) : Boolean;
      
      function cancel() : void;
      
      function get finish() : Boolean;
   }
}
