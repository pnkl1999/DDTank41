package game.motions
{
   import flash.geom.Point;
   
   public class BaseMotionFunc implements IMotionFunction
   {
       
      
      protected var _initial:Point;
      
      protected var _final:Point;
      
      protected var _result:Object;
      
      protected var _lifetime:int;
      
      protected var _isPlaying:Boolean;
      
      public function BaseMotionFunc(param1:Object)
      {
         super();
         this._lifetime = 0;
         this._initial = new Point(0,0);
         if(param1.initial)
         {
            this._initial = param1.initial;
         }
         this._final = new Point(0,0);
         if(param1.final)
         {
            this._final = param1.final;
         }
      }
      
      public function getVectorByTime(param1:int) : Object
      {
         return null;
      }
      
      public function getResult() : Object
      {
         if(!this._isPlaying)
         {
            return null;
         }
         return null;
      }
   }
}
