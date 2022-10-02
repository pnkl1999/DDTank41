package trainer.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.PlayerManager;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import flash.utils.setTimeout;
   import trainer.controller.WeakGuildManager;
   import trainer.data.Step;
   
   public class NewHandContainer
   {
      
      private static var _instance:NewHandContainer;
       
      
      private var _arrows:Dictionary;
      
      private var _movies:Dictionary;
      
      public function NewHandContainer(param1:NewHandContainerEnforcer)
      {
         super();
         this._arrows = new Dictionary();
         this._movies = new Dictionary();
      }
      
      public static function get Instance() : NewHandContainer
      {
         if(!_instance)
         {
            _instance = new NewHandContainer(new NewHandContainerEnforcer());
         }
         return _instance;
      }
      
      public function showArrow(param1:int, param2:int, param3:*, param4:String = "", param5:String = "", param6:DisplayObjectContainer = null, param7:int = 0, param8:Boolean = false) : void
      {
         var _loc10_:Point = null;
         var _loc11_:MovieClip = null;
         var _loc12_:MovieClip = null;
         var _loc13_:Point = null;
         _loc10_ = null;
         _loc11_ = null;
         _loc12_ = null;
         _loc13_ = null;
         if(this.hasArrow(param1))
         {
            this.clearArrow(param1);
         }
         if(!WeakGuildManager.Instance.switchUserGuide || PlayerManager.Instance.Self.IsWeakGuildFinish(Step.OLD_PLAYER))
         {
            return;
         }
         var _loc9_:Object = {};
         _loc10_ = ComponentFactory.Instance.creatCustomObject(param3);
         _loc11_ = ClassUtils.CreatInstance("asset.trainer.TrainerArrowAsset");
         _loc11_.mouseChildren = false;
         _loc11_.mouseEnabled = false;
         _loc11_.rotation = param2;
         _loc11_.x = _loc10_.x;
         _loc11_.y = _loc10_.y;
         if(param6)
         {
            param6.addChild(_loc11_);
         }
         else
         {
            LayerManager.Instance.addToLayer(_loc11_,LayerManager.GAME_TOP_LAYER,false,LayerManager.NONE_BLOCKGOUND);
         }
         _loc9_["arrow"] = _loc11_;
         if(param4 != "")
         {
            _loc12_ = ClassUtils.CreatInstance(param4);
            _loc12_.mouseChildren = false;
            _loc12_.mouseEnabled = false;
            if(param5 != "")
            {
               _loc13_ = ComponentFactory.Instance.creatCustomObject(param5);
               _loc12_.x = _loc13_.x;
               _loc12_.y = _loc13_.y;
            }
            if(param6)
            {
               param6.addChild(_loc12_);
            }
            else
            {
               LayerManager.Instance.addToLayer(_loc12_,LayerManager.GAME_TOP_LAYER,false,LayerManager.NONE_BLOCKGOUND);
            }
            _loc9_["tip"] = _loc12_;
         }
         this._arrows[param1] = _loc9_;
         if(param7 > 0)
         {
            setTimeout(this.clearArrow,param7,param1);
         }
      }
      
      public function clearArrowByID(param1:int) : void
      {
         var _loc2_:* = null;
         if(param1 == -1)
         {
            for(_loc2_ in this._arrows)
            {
               this.clearArrow(int(_loc2_));
            }
         }
         else
         {
            this.clearArrow(param1);
         }
      }
      
      public function hasArrow(param1:int) : Boolean
      {
         return this._arrows[param1] != null;
      }
      
      public function showMovie(param1:String, param2:String = "") : void
      {
         var _loc3_:MovieClip = null;
         _loc3_ = null;
         var _loc4_:Point = null;
         if(this._movies[param1])
         {
            throw new Error("Already has a arrow with this id!");
         }
         _loc3_ = ClassUtils.CreatInstance(param1);
         _loc3_.mouseChildren = false;
         _loc3_.mouseEnabled = false;
         if(param2 != "")
         {
            _loc4_ = ComponentFactory.Instance.creatCustomObject(param2);
            _loc3_.x = _loc4_.x;
            _loc3_.y = _loc4_.y;
         }
         LayerManager.Instance.addToLayer(_loc3_,LayerManager.GAME_DYNAMIC_LAYER,false,LayerManager.NONE_BLOCKGOUND);
         this._movies[param1] = _loc3_;
      }
      
      public function hideMovie(param1:String) : void
      {
         var _loc2_:* = null;
         if(param1 == "-1")
         {
            for(_loc2_ in this._movies)
            {
               this.clearMovie(_loc2_);
            }
         }
         else
         {
            this.clearMovie(param1);
         }
      }
      
      private function clearArrow(param1:int) : void
      {
         var _loc2_:Object = this._arrows[param1];
         if(_loc2_)
         {
            ObjectUtils.disposeObject(_loc2_["arrow"]);
            ObjectUtils.disposeObject(_loc2_["tip"]);
         }
         delete this._arrows[param1];
      }
      
      private function clearMovie(param1:String) : void
      {
         ObjectUtils.disposeObject(this._movies[param1]);
         delete this._movies[param1];
      }
      
      public function dispose() : void
      {
         _instance = null;
         this._arrows = null;
         this._movies = null;
      }
   }
}

class NewHandContainerEnforcer
{
    
   
   function NewHandContainerEnforcer()
   {
      super();
   }
}
