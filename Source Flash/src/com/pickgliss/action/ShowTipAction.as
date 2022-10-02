package com.pickgliss.action
{
   import com.pickgliss.ui.ComponentSetting;
   import com.pickgliss.ui.LayerManager;
   import flash.display.DisplayObject;
   
   public class ShowTipAction extends BaseAction
   {
       
      
      private var _tip:DisplayObject;
      
      private var _sound:String;
      
      public function ShowTipAction(param1:DisplayObject, param2:String = null)
      {
         super();
         this._tip = param1;
         this._sound = param2;
      }
      
      override public function act() : void
      {
         if(this._sound && ComponentSetting.PLAY_SOUND_FUNC is Function)
         {
            ComponentSetting.PLAY_SOUND_FUNC(this._sound);
         }
         LayerManager.Instance.addToLayer(this._tip,LayerManager.GAME_TOP_LAYER,false,LayerManager.NONE_BLOCKGOUND,false);
      }
   }
}
