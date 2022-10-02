package com.pickgliss.effect
{
   import flash.display.DisplayObject;
   import flash.utils.Dictionary;
   
   public final class EffectManager
   {
      
      private static var _instance:EffectManager;
       
      
      private var _effects:Dictionary;
      
      private var _effectIDCounter:int = 0;
      
      public function EffectManager()
      {
         super();
         this._effects = new Dictionary();
      }
      
      public static function get Instance() : EffectManager
      {
         if(_instance == null)
         {
            _instance = new EffectManager();
         }
         return _instance;
      }
      
      public function getEffectID() : int
      {
         return this._effectIDCounter++;
      }
      
      public function creatEffect(param1:int, param2:DisplayObject, ... rest) : IEffect
      {
         var _loc4_:IEffect = this.creatEffectByEffectType(param1);
         _loc4_.initEffect(param2,rest);
         this._effects[_loc4_.id] = _loc4_;
         return _loc4_;
      }
      
      public function getEffectByTarget(param1:DisplayObject) : IEffect
      {
         var _loc2_:IEffect = null;
         for each(_loc2_ in this._effects)
         {
            if(param1 == _loc2_.target)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function removeEffect(param1:IEffect) : void
      {
         param1.dispose();
         delete this._effects[param1.id];
      }
      
      public function creatEffectByEffectType(param1:int) : IEffect
      {
         var _loc2_:IEffect = null;
         switch(param1)
         {
            case EffectTypes.ADD_MOVIE_EFFECT:
               _loc2_ = new AddMovieEffect(this.getEffectID());
               break;
            case EffectTypes.SHINER_ANIMATION:
               _loc2_ = new ShinerAnimation(this.getEffectID());
               break;
            case EffectTypes.ALPHA_SHINER_ANIMATION:
               _loc2_ = new AlphaShinerAnimation(this.getEffectID());
               break;
            case EffectTypes.Linear_SHINER_ANIMATION:
               _loc2_ = new LinearShinerAnimation(this.getEffectID());
         }
         return _loc2_;
      }
   }
}
