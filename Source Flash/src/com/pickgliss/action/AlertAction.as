package com.pickgliss.action
{
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentSetting;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   
   public class AlertAction extends BaseAction
   {
       
      
      private var _alert:BaseAlerFrame;
      
      private var _layerType:int;
      
      private var _blockBackgound:int;
      
      private var _soundStr:String;
      
      private var _center:Boolean;
      
      public function AlertAction(param1:BaseAlerFrame, param2:int, param3:int, param4:String = null, param5:Boolean = true)
      {
         super();
         this._alert = param1;
         this._layerType = param2;
         this._blockBackgound = param3;
         this._soundStr = param4;
         this._center = param5;
      }
      
      override public function act() : void
      {
         if(this._soundStr && ComponentSetting.PLAY_SOUND_FUNC is Function)
         {
            ComponentSetting.PLAY_SOUND_FUNC(this._soundStr);
         }
         LayerManager.Instance.addToLayer(this._alert,this._layerType,this._alert.info.frameCenter,this._blockBackgound);
         StageReferance.stage.focus = this._alert;
      }
   }
}
