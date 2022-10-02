package com.pickgliss.ui.vo
{
   import com.pickgliss.events.InteractiveEvent;
   import com.pickgliss.ui.ComponentSetting;
   import flash.events.EventDispatcher;
   import flash.geom.Point;
   
   public class AlertInfo extends EventDispatcher
   {
      
      public static const CANCEL_LABEL:String = "Hủy bỏ";
      
      public static const SUBMIT_LABEL:String = "Đồng ý";
       
      
      private var _type:int;
      
      private var _customPos:Point;
      
      private var _autoButtonGape:Boolean = true;
      
      private var _autoDispose:Boolean = false;
      
      private var _bottomGap:int;
      
      private var _buttonGape:int;
      
      private var _cancelLabel:String = "Hủy bỏ";
      
      private var _data:Object;
      
      private var _enableHtml:Boolean;
      
      private var _enterEnable:Boolean = true;
      
      private var _escEnable:Boolean = true;
      
      private var _frameCenter:Boolean = true;
      
      private var _moveEnable:Boolean = true;
      
      private var _mutiline:Boolean;
      
      private var _showCancel:Boolean = true;
      
      private var _showSubmit:Boolean = true;
      
      private var _submitEnabled:Boolean = true;
      
      private var _cancelEnabled:Boolean = true;
      
      private var _submitLabel:String = "Đồng ý";
      
      private var _textShowHeight:int;
      
      private var _textShowWidth:int;
      
      private var _title:String;
      
      private var _soundID:*;
	  
	  private var _selectBtnY:int;
      
      public function AlertInfo(param1:String = "", param2:String = "Đồng ý", param3:String = "Hủy bỏ", param4:Boolean = true, param5:Boolean = true, param6:Object = null, param7:Boolean = true, param8:Boolean = true, param9:Boolean = true, param10:Boolean = true, param11:int = 20, param12:int = 30, param13:Boolean = false, param14:int = 0)
      {
         this._buttonGape = ComponentSetting.ALERT_BUTTON_GAPE;
         super();
         this.title = param1;
         this.type = param14;
         this.submitLabel = param2;
         this.cancelLabel = param3;
         this.showSubmit = param4;
         this.showCancel = param5;
         this.data = param6;
         this.frameCenter = param7;
         this.moveEnable = param8;
         this.enterEnable = param9;
         this.escEnable = param10;
         this.bottomGap = param11;
         this.buttonGape = param12;
         this.autoDispose = param13;
      }
      
      public function get autoButtonGape() : Boolean
      {
         return this._autoButtonGape;
      }
      
      public function set autoButtonGape(param1:Boolean) : void
      {
         if(this._autoButtonGape == param1)
         {
            return;
         }
         this._autoButtonGape = param1;
         this.fireChange();
      }
      
      public function get autoDispose() : Boolean
      {
         return this._autoDispose;
      }
      
      public function set autoDispose(param1:Boolean) : void
      {
         if(this._autoDispose == param1)
         {
            return;
         }
         this._autoDispose = param1;
         this.fireChange();
      }
      
      public function get type() : int
      {
         return this._type;
      }
      
      public function set type(param1:int) : void
      {
         if(this._type == param1)
         {
            return;
         }
         this._type = param1;
         this.fireChange();
      }
      
      public function get bottomGap() : int
      {
         return this._bottomGap;
      }
      
      public function set bottomGap(param1:int) : void
      {
         if(this._bottomGap == param1)
         {
            return;
         }
         this._bottomGap = param1;
         this.fireChange();
      }
      
      public function get buttonGape() : int
      {
         return this._buttonGape;
      }
      
      public function set buttonGape(param1:int) : void
      {
         if(this._buttonGape == param1)
         {
            return;
         }
         this._buttonGape = param1;
         this.fireChange();
      }
      
      public function get cancelLabel() : String
      {
         return this._cancelLabel;
      }
      
      public function set cancelLabel(param1:String) : void
      {
         if(this._cancelLabel == param1)
         {
            return;
         }
         this._cancelLabel = param1;
         this.fireChange();
      }
      
      public function get submitEnabled() : Boolean
      {
         return this._submitEnabled;
      }
      
      public function set submitEnabled(param1:Boolean) : void
      {
         if(this._submitEnabled != param1)
         {
            this._submitEnabled = param1;
            this.fireChange();
         }
      }
      
      public function get cancelEnabled() : Boolean
      {
         return this._cancelEnabled;
      }
      
      public function set cancelEnabled(param1:Boolean) : void
      {
         if(this._cancelEnabled != param1)
         {
            this._cancelEnabled = param1;
            this.fireChange();
         }
      }
      
      public function get data() : Object
      {
         return this._data;
      }
      
      public function set data(param1:Object) : void
      {
         if(this._data == param1)
         {
            return;
         }
         this._data = param1;
         this.fireChange();
      }
      
      public function get enableHtml() : Boolean
      {
         return this._enableHtml;
      }
      
      public function set enableHtml(param1:Boolean) : void
      {
         if(this._enableHtml == param1)
         {
            return;
         }
         this._enableHtml = param1;
         this.fireChange();
      }
      
      public function get enterEnable() : Boolean
      {
         return this._enterEnable;
      }
      
      public function set enterEnable(param1:Boolean) : void
      {
         if(this._enterEnable == param1)
         {
            return;
         }
         this._enterEnable = param1;
         this.fireChange();
      }
      
      public function get escEnable() : Boolean
      {
         return this._escEnable;
      }
      
      public function set escEnable(param1:Boolean) : void
      {
         if(this._escEnable == param1)
         {
            return;
         }
         this._escEnable = param1;
         this.fireChange();
      }
      
      public function get frameCenter() : Boolean
      {
         return this._frameCenter;
      }
      
      public function set frameCenter(param1:Boolean) : void
      {
         if(this._frameCenter == param1)
         {
            return;
         }
         this._frameCenter = param1;
         this.fireChange();
      }
      
      public function get moveEnable() : Boolean
      {
         return this._moveEnable;
      }
      
      public function set moveEnable(param1:Boolean) : void
      {
         if(this._moveEnable == param1)
         {
            return;
         }
         this._moveEnable = param1;
         this.fireChange();
      }
      
      public function get mutiline() : Boolean
      {
         return this._mutiline;
      }
      
      public function set mutiline(param1:Boolean) : void
      {
         if(this._mutiline == param1)
         {
            return;
         }
         this._mutiline = param1;
         this.fireChange();
      }
      
      public function get showCancel() : Boolean
      {
         return this._showCancel;
      }
      
      public function set showCancel(param1:Boolean) : void
      {
         if(this._showCancel == param1)
         {
            return;
         }
         this._showCancel = param1;
         this.fireChange();
      }
      
      public function get showSubmit() : Boolean
      {
         return this._showSubmit;
      }
      
      public function set showSubmit(param1:Boolean) : void
      {
         if(this._showSubmit == param1)
         {
            return;
         }
         this._showSubmit = param1;
         this.fireChange();
      }
      
      public function get submitLabel() : String
      {
         return this._submitLabel;
      }
      
      public function set submitLabel(param1:String) : void
      {
         if(this._submitLabel == param1)
         {
            return;
         }
         this._submitLabel = param1;
         this.fireChange();
      }
      
      public function get textShowHeight() : int
      {
         return this._textShowHeight;
      }
      
      public function set textShowHeight(param1:int) : void
      {
         if(this._textShowHeight == param1)
         {
            return;
         }
         this._textShowHeight = param1;
         this.fireChange();
      }
      
      public function get textShowWidth() : int
      {
         return this._textShowWidth;
      }
      
      public function set textShowWidth(param1:int) : void
      {
         if(this._textShowWidth == param1)
         {
            return;
         }
         this._textShowWidth = param1;
         this.fireChange();
      }
      
      public function get title() : String
      {
         return this._title;
      }
      
      public function set title(param1:String) : void
      {
         if(this._title == param1)
         {
            return;
         }
         this._title = param1;
         this.fireChange();
      }
      
      public function get sound() : *
      {
         return this._soundID;
      }
      
      public function set sound(param1:*) : void
      {
         if(this._soundID == param1)
         {
            return;
         }
         this._soundID = param1;
         this.fireChange();
      }
      
      private function fireChange() : void
      {
         dispatchEvent(new InteractiveEvent(InteractiveEvent.STATE_CHANGED));
      }
      
      public function get customPos() : Point
      {
         return this._customPos;
      }
      
      public function set customPos(param1:Point) : void
      {
         this._customPos = param1;
      }
	  
	  public function get selectBtnY() : int
	  {
		  return this._selectBtnY;
	  }
	  
	  public function set selectBtnY(param1:int) : void
	  {
		  this._selectBtnY = param1;
	  }
   }
}
