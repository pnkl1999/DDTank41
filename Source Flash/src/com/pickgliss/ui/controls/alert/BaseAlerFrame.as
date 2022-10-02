package com.pickgliss.ui.controls.alert
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.InteractiveEvent;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ComponentSetting;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.DisplayObject;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;
   
   public class BaseAlerFrame extends Frame
   {
      
      public static const P_buttonToBottom:String = "buttonToBottom";
      
      public static const P_cancelButton:String = "submitButton";
      
      public static const P_info:String = "info";
      
      public static const P_submitButton:String = "submitButton";
       
      
      protected var _buttonToBottom:int;
      
      protected var _cancelButton:BaseButton;
      
      protected var _cancelButtonStyle:String;
      
      protected var _info:AlertInfo;
      
      protected var _sound:*;
      
      protected var _submitButton:BaseButton;
      
      protected var _submitButtonStyle:String;
      
      protected var _isBand:Boolean;
      
      public function BaseAlerFrame()
      {
         super();
      }
      
      public function set buttonToBottom(param1:int) : void
      {
         if(this._buttonToBottom == param1)
         {
            return;
         }
         this._buttonToBottom = param1;
         onPropertiesChanged(P_buttonToBottom);
      }
      
      public function set cancelButtonEnable(param1:Boolean) : void
      {
         this._cancelButton.enable = param1;
      }
      
      public function set cancelButtonStyle(param1:String) : void
      {
         if(this._cancelButtonStyle == param1)
         {
            return;
         }
         this._cancelButtonStyle = param1;
         this._cancelButton = ComponentFactory.Instance.creat(this._cancelButtonStyle);
         onPropertiesChanged(P_cancelButton);
      }
      
      override public function dispose() : void
      {
         var _loc1_:DisplayObject = StageReferance.stage.focus as DisplayObject;
         if(_loc1_ && contains(_loc1_))
         {
            StageReferance.stage.focus = null;
         }
         if(this._submitButton)
         {
            this._submitButton.removeEventListener(MouseEvent.CLICK,this.__onSubmitClick);
            ObjectUtils.disposeObject(this._submitButton);
            this._submitButton = null;
         }
         if(this._cancelButton)
         {
            this._cancelButton.removeEventListener(MouseEvent.CLICK,this.__onCancelClick);
            ObjectUtils.disposeObject(this._cancelButton);
            this._cancelButton = null;
         }
         removeEventListener(KeyboardEvent.KEY_DOWN,this.__onKeyDown);
         this._info = null;
         super.dispose();
      }
      
      public function get info() : AlertInfo
      {
         return this._info;
      }
      
      public function get isBand() : Boolean
      {
         return this._isBand;
      }
      
      public function set isBand(param1:Boolean) : void
      {
         this._isBand = param1;
      }
      
      public function set info(param1:AlertInfo) : void
      {
         if(this._info == param1)
         {
            return;
         }
         if(this._info)
         {
            this._info.removeEventListener(InteractiveEvent.STATE_CHANGED,this.__onInfoChanged);
         }
         this._info = param1;
         this._info.addEventListener(InteractiveEvent.STATE_CHANGED,this.__onInfoChanged);
         onPropertiesChanged(P_info);
      }
      
      public function set submitButtonEnable(param1:Boolean) : void
      {
         this._submitButton.enable = param1;
      }
      
      public function set submitButtonStyle(param1:String) : void
      {
         if(this._submitButtonStyle == param1)
         {
            return;
         }
         this._submitButtonStyle = param1;
         this._submitButton = ComponentFactory.Instance.creat(this._submitButtonStyle);
         onPropertiesChanged(P_submitButton);
      }
      
      protected function __onCancelClick(param1:MouseEvent) : void
      {
         if(this._sound != null)
         {
            ComponentSetting.PLAY_SOUND_FUNC(this._sound);
         }
         this.onResponse(FrameEvent.CANCEL_CLICK);
      }
      
      override protected function __onCloseClick(param1:MouseEvent) : void
      {
         if(this._sound != null)
         {
            ComponentSetting.PLAY_SOUND_FUNC(this._sound);
         }
         super.__onCloseClick(param1);
      }
      
      override protected function __onKeyDown(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.ENTER && enterEnable || param1.keyCode == Keyboard.ESCAPE && escEnable)
         {
            if(this._sound != null)
            {
               ComponentSetting.PLAY_SOUND_FUNC(this._sound);
            }
         }
         super.__onKeyDown(param1);
      }
      
      protected function __onSubmitClick(param1:MouseEvent) : void
      {
         if(this._sound != null)
         {
            ComponentSetting.PLAY_SOUND_FUNC(this._sound);
         }
         this.onResponse(FrameEvent.SUBMIT_CLICK);
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
         if(this._submitButton)
         {
            addChild(this._submitButton);
         }
         if(this._cancelButton)
         {
            addChild(this._cancelButton);
         }
      }
      
      override protected function onProppertiesUpdate() : void
      {
         if(_changedPropeties[P_info])
         {
            this._sound = this._info.sound;
            _escEnable = this._info.escEnable;
            _enterEnable = this.info.enterEnable;
            _titleText = this._info.title;
            _changedPropeties[Frame.P_titleText] = true;
            _moveEnable = this._info.moveEnable;
            _changedPropeties[Frame.P_moveEnable] = true;
         }
         super.onProppertiesUpdate();
         if(_changedPropeties[P_info] || _changedPropeties[P_submitButton] || _changedPropeties[P_cancelButton])
         {
            if(this._cancelButton && this._info)
            {
               this._cancelButton.visible = this._info.showCancel;
               this._cancelButton.enable = this._info.cancelEnabled;
               if(this._cancelButton is TextButton)
               {
                  TextButton(this._cancelButton).text = this._info.cancelLabel;
               }
               if(this._cancelButton.visible)
               {
                  this._cancelButton.addEventListener(MouseEvent.CLICK,this.__onCancelClick);
               }
            }
            if(this._submitButton && this._info)
            {
               this._submitButton.visible = this._info.showSubmit;
               this._submitButton.enable = this._info.submitEnabled;
               if(this._submitButton is TextButton)
               {
                  TextButton(this._submitButton).text = this._info.submitLabel;
               }
               if(this._submitButton.visible)
               {
                  this._submitButton.addEventListener(MouseEvent.CLICK,this.__onSubmitClick);
               }
            }
         }
         if(_changedPropeties[P_info] || _changedPropeties[Component.P_height] || _changedPropeties[Component.P_width] || _changedPropeties[P_buttonToBottom])
         {
            this.updatePos();
         }
      }
      
      override protected function onResponse(param1:int) : void
      {
         if(this._info && this._info.autoDispose)
         {
            this.dispose();
         }
         super.onResponse(param1);
      }
      
      protected function updatePos() : void
      {
         if(this._info == null)
         {
            return;
         }
         if(this._info.bottomGap)
         {
            this._buttonToBottom = int(this._info.bottomGap);
         }
         if(this._submitButton)
         {
            this._submitButton.y = _height - this._submitButton.height - this._buttonToBottom;
         }
         if(this._cancelButton)
         {
            this._cancelButton.y = _height - this._cancelButton.height - this._buttonToBottom;
         }
         if(this._info.showCancel || this._info.showSubmit)
         {
            if(this._info.customPos)
            {
               if(this._submitButton)
               {
                  this._submitButton.x = this._info.customPos.x;
                  this._submitButton.y = this._info.customPos.y;
                  if(this._cancelButton)
                  {
                     this._cancelButton.x = this._info.customPos.x + this._cancelButton.width + this._info.buttonGape;
                     this._cancelButton.y = this._info.customPos.y;
                  }
               }
               else if(this._cancelButton)
               {
                  this._cancelButton.x = this._info.customPos.x;
                  this._cancelButton.y = this._info.customPos.y;
               }
            }
            else
            {
               if(this._info.autoButtonGape)
               {
                  if(this._submitButton != null && this._cancelButton != null)
                  {
                     this._info.buttonGape = (_width - this._submitButton.width - this._cancelButton.width) / 2;
                  }
               }
               if(!this._info.showCancel && this._submitButton)
               {
                  this._submitButton.x = (_width - this._submitButton.width) / 2;
               }
               else if(!this._info.showSubmit && this._cancelButton)
               {
                  this._cancelButton.x = (_width - this._cancelButton.width) / 2;
               }
               else if(this._cancelButton != null && this._submitButton != null)
               {
                  this._submitButton.x = (_width - this._submitButton.width - this._cancelButton.width - this._info.buttonGape) / 2;
                  this._cancelButton.x = this._submitButton.x + this._submitButton.width + this._info.buttonGape;
               }
            }
         }
      }
      
      private function __onInfoChanged(param1:InteractiveEvent) : void
      {
         onPropertiesChanged(P_info);
      }
   }
}
