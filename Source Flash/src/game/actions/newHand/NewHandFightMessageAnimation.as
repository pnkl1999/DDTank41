package game.actions.newHand
{
   import com.greensock.TweenMax;
   import com.greensock.easing.Quint;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   internal class NewHandFightMessageAnimation implements Disposeable
   {
       
      
      private var _duration:Number;
      
      private var _tipContent:DisplayObject;
      
      private var _tipContainer:Sprite;
      
      function NewHandFightMessageAnimation(param1:String, param2:Number, param3:Boolean = true)
      {
         super();
         this._duration = param2;
         this._tipContainer = new Sprite();
         this._tipContainer.mouseEnabled = false;
         this._tipContainer.mouseChildren = false;
         this._tipContainer.y = StageReferance.stageHeight >> 1;
         this._tipContent = ComponentFactory.Instance.creat(param1);
         this._tipContainer.addChild(this._tipContent);
         this._tipContainer.x = StageReferance.stageWidth - this._tipContent.width >> 1;
         if(param3)
         {
            this.show();
         }
      }
      
      public function show() : void
      {
         var _loc1_:int = (StageReferance.stageHeight - this._tipContainer.height) / 2 - 10;
         TweenMax.fromTo(this._tipContainer,0.3,{
            "y":StageReferance.stageHeight / 2 + 20,
            "alpha":0,
            "ease":Quint.easeIn,
            "onComplete":this.onTipToCenter
         },{
            "y":_loc1_,
            "alpha":1
         });
         LayerManager.Instance.addToLayer(this._tipContainer,LayerManager.STAGE_DYANMIC_LAYER,false,0,false);
      }
      
      private function onTipToCenter() : void
      {
         TweenMax.to(this._tipContainer,this._duration,{
            "alpha":0,
            "ease":Quint.easeOut,
            "onComplete":this.dispose,
            "delay":1.2
         });
      }
      
      public function dispose() : void
      {
         TweenMax.killTweensOf(this._tipContainer);
         if(this._tipContent)
         {
            ObjectUtils.disposeObject(this._tipContent);
         }
         this._tipContent = null;
         if(this._tipContainer)
         {
            ObjectUtils.disposeObject(this._tipContainer);
         }
         this._tipContainer = null;
      }
   }
}
