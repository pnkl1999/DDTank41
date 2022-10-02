package com.pickgliss.ui.controls
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.geom.InnerRectangle;
   import com.pickgliss.geom.OuterRectPos;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.DisplayObject;
   import flash.display.InteractiveObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import flash.ui.Keyboard;
   
   [Event(name="response",type="com.pickgliss.events.FrameEvent")]
   public class Frame extends Component
   {
      
      public static const P_backgound:String = "backgound";
      
      public static const P_closeButton:String = "closeButton";
      
      public static const P_closeInnerRect:String = "closeInnerRect";
      
      public static const P_containerX:String = "containerX";
      
      public static const P_containerY:String = "containerY";
      
      public static const P_disposeChildren:String = "disposeChildren";
      
      public static const P_moveEnable:String = "moveEnable";
      
      public static const P_moveInnerRect:String = "moveInnerRect";
      
      public static const P_title:String = "title";
      
      public static const P_titleText:String = "titleText";
      
      public static const P_titleOuterRectPos:String = "titleOuterRectPos";
      
      public static const P_escEnable:String = "escEnable";
      
      public static const P_enterEnable:String = "enterEnable";
       
      
      protected var _backStyle:String;
      
      protected var _backgound:DisplayObject;
      
      protected var _closeButton:BaseButton;
      
      protected var _closeInnerRect:InnerRectangle;
      
      protected var _closeInnerRectString:String;
      
      protected var _closestyle:String;
      
      protected var _container:Sprite;
      
      protected var _containerPosString:String;
      
      protected var _containerX:Number;
      
      protected var _containerY:Number;
      
      protected var _moveEnable:Boolean;
      
      protected var _moveInnerRect:InnerRectangle;
      
      protected var _moveInnerRectString:String = "";
      
      protected var _moveRect:Sprite;
      
      protected var _title:TextField;
      
      protected var _titleStyle:String;
      
      protected var _titleText:String = "";
      
      protected var _disposeChildren:Boolean = true;
      
      protected var _titleOuterRectPosString:String;
      
      protected var _titleOuterRectPos:OuterRectPos;
      
      protected var _escEnable:Boolean;
      
      protected var _enterEnable:Boolean;
      
      public function Frame()
      {
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.__onAddToStage);
         addEventListener(MouseEvent.MOUSE_DOWN,this.__onMouseClickSetFocus);
      }
      
      protected function __onMouseClickSetFocus(param1:MouseEvent) : void
      {
         StageReferance.stage.focus = param1.target as InteractiveObject;
      }
      
      public function addToContent(param1:DisplayObject) : void
      {
         this._container.addChild(param1);
      }
      
      public function set backStyle(param1:String) : void
      {
         if(this._backStyle == param1)
         {
            return;
         }
         this._backStyle = param1;
         this.backgound = ComponentFactory.Instance.creat(this._backStyle);
      }
      
      public function set backgound(param1:DisplayObject) : void
      {
         if(this._backgound == param1)
         {
            return;
         }
         ObjectUtils.disposeObject(this._backgound);
         this._backgound = param1;
         if(this._backgound is InteractiveObject)
         {
            InteractiveObject(this._backgound).mouseEnabled = true;
         }
         onPropertiesChanged(P_backgound);
      }
      
      public function get closeButton() : BaseButton
      {
         return this._closeButton;
      }
      
      public function set closeButton(param1:BaseButton) : void
      {
         if(this._closeButton == param1)
         {
            return;
         }
         if(this._closeButton)
         {
            this._closeButton.removeEventListener(MouseEvent.CLICK,this.__onCloseClick);
            ObjectUtils.disposeObject(this._closeButton);
         }
         this._closeButton = param1;
         onPropertiesChanged(P_closeButton);
      }
      
      public function set closeInnerRectString(param1:String) : void
      {
         if(this._closeInnerRectString == param1)
         {
            return;
         }
         this._closeInnerRectString = param1;
         this._closeInnerRect = ClassUtils.CreatInstance(ClassUtils.INNERRECTANGLE,ComponentFactory.parasArgs(this._closeInnerRectString));
         onPropertiesChanged(P_closeInnerRect);
      }
      
      public function set closestyle(param1:String) : void
      {
         if(this._closestyle == param1)
         {
            return;
         }
         this._closestyle = param1;
         this.closeButton = ComponentFactory.Instance.creat(this._closestyle);
      }
      
      public function set containerX(param1:Number) : void
      {
         if(this._containerX == param1)
         {
            return;
         }
         this._containerX = param1;
         onPropertiesChanged(P_containerX);
      }
      
      public function set containerY(param1:Number) : void
      {
         if(this._containerY == param1)
         {
            return;
         }
         this._containerY = param1;
         onPropertiesChanged(P_containerY);
      }
      
      public function set titleOuterRectPosString(param1:String) : void
      {
         if(this._titleOuterRectPosString == param1)
         {
            return;
         }
         this._titleOuterRectPosString = param1;
         this._titleOuterRectPos = ClassUtils.CreatInstance(ClassUtils.OUTTERRECPOS,ComponentFactory.parasArgs(this._titleOuterRectPosString));
         onPropertiesChanged(P_titleOuterRectPos);
      }
      
      override public function dispose() : void
      {
         var _loc1_:DisplayObject = StageReferance.stage.focus as DisplayObject;
         if(_loc1_ && contains(_loc1_))
         {
            StageReferance.stage.focus = null;
         }
         StageReferance.stage.removeEventListener(MouseEvent.MOUSE_UP,this.__onFrameMoveStop);
         StageReferance.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.__onMoveWindow);
         StageReferance.stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.__onKeyDown);
         removeEventListener(MouseEvent.MOUSE_DOWN,this.__onMouseClickSetFocus);
         removeEventListener(Event.ADDED_TO_STAGE,this.__onAddToStage);
         if(this._backgound)
         {
            ObjectUtils.disposeObject(this._backgound);
         }
         this._backgound = null;
         if(this._closeButton)
         {
            this._closeButton.removeEventListener(MouseEvent.CLICK,this.__onCloseClick);
            ObjectUtils.disposeObject(this._closeButton);
         }
         this._closeButton = null;
         if(this._title)
         {
            ObjectUtils.disposeObject(this._title);
         }
         this._title = null;
         if(this._disposeChildren)
         {
            ObjectUtils.disposeAllChildren(this._container);
         }
         if(this._container)
         {
            ObjectUtils.disposeObject(this._container);
         }
         this._container = null;
         if(this._moveRect)
         {
            this._moveRect.removeEventListener(MouseEvent.MOUSE_DOWN,this.__onFrameMoveStart);
         }
         ObjectUtils.disposeObject(this._moveRect);
         this._moveRect = null;
         super.dispose();
      }
      
      public function get disposeChildren() : Boolean
      {
         return this._disposeChildren;
      }
      
      public function set disposeChildren(param1:Boolean) : void
      {
         if(this._disposeChildren == param1)
         {
            return;
         }
         this._disposeChildren = param1;
         onPropertiesChanged(P_disposeChildren);
      }
      
      public function set moveEnable(param1:Boolean) : void
      {
         if(this._moveEnable == param1)
         {
            return;
         }
         this._moveEnable = param1;
         onPropertiesChanged(P_moveEnable);
      }
      
      public function set moveInnerRectString(param1:String) : void
      {
         if(this._moveInnerRectString == param1)
         {
            return;
         }
         this._moveInnerRectString = param1;
         this._moveInnerRect = ClassUtils.CreatInstance(ClassUtils.INNERRECTANGLE,ComponentFactory.parasArgs(this._moveInnerRectString));
         onPropertiesChanged(P_moveInnerRect);
      }
      
      public function set title(param1:TextField) : void
      {
         if(this._title == param1)
         {
            return;
         }
         this._title = param1;
         onPropertiesChanged(P_title);
      }
      
      public function set titleStyle(param1:String) : void
      {
         if(this._titleStyle == param1)
         {
            return;
         }
         this._titleStyle = param1;
         this.title = ComponentFactory.Instance.creat(this._titleStyle);
      }
      
      public function set titleText(param1:String) : void
      {
         if(this._titleText == param1)
         {
            return;
         }
         this._titleText = param1;
         onPropertiesChanged(P_titleText);
      }
      
      protected function __onAddToStage(param1:Event) : void
      {
         stage.focus = this;
      }
      
      protected function __onCloseClick(param1:MouseEvent) : void
      {
         this.onResponse(FrameEvent.CLOSE_CLICK);
      }
      
      protected function __onKeyDown(param1:KeyboardEvent) : void
      {
         var _loc2_:DisplayObject = StageReferance.stage.focus as DisplayObject;
         if(DisplayUtils.isTargetOrContain(_loc2_,this))
         {
            if(param1.keyCode == Keyboard.ENTER && this.enterEnable)
            {
               if(_loc2_ is TextField && TextField(_loc2_).type == TextFieldType.INPUT)
               {
                  return;
               }
               this.onResponse(FrameEvent.ENTER_CLICK);
               param1.stopImmediatePropagation();
            }
            else if(param1.keyCode == Keyboard.ESCAPE && this.escEnable)
            {
               this.onResponse(FrameEvent.ESC_CLICK);
               param1.stopImmediatePropagation();
            }
         }
      }
      
      public function set escEnable(param1:Boolean) : void
      {
         if(this._escEnable == param1)
         {
            return;
         }
         this._escEnable = param1;
         onPropertiesChanged(P_escEnable);
      }
      
      public function get escEnable() : Boolean
      {
         return this._escEnable;
      }
      
      public function set enterEnable(param1:Boolean) : void
      {
         if(this._enterEnable == param1)
         {
            return;
         }
         this._enterEnable = param1;
         onPropertiesChanged(P_enterEnable);
      }
      
      public function get enterEnable() : Boolean
      {
         return this._enterEnable;
      }
      
      protected function onResponse(param1:int) : void
      {
         dispatchEvent(new FrameEvent(param1));
      }
      
      protected function __onFrameMoveStart(param1:MouseEvent) : void
      {
         StageReferance.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.__onMoveWindow);
         StageReferance.stage.addEventListener(MouseEvent.MOUSE_UP,this.__onFrameMoveStop);
         startDrag();
      }
      
      protected function __onFrameMoveStop(param1:MouseEvent) : void
      {
         StageReferance.stage.removeEventListener(MouseEvent.MOUSE_UP,this.__onFrameMoveStop);
         StageReferance.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.__onMoveWindow);
         stopDrag();
      }
      
      override protected function addChildren() : void
      {
         if(this._backgound)
         {
            addChild(this._backgound);
         }
         if(this._title)
         {
            addChild(this._title);
         }
         addChild(this._moveRect);
         addChild(this._container);
         if(this._closeButton)
         {
            addChild(this._closeButton);
         }
      }
      
      override protected function init() : void
      {
         this._container = new Sprite();
         this._moveRect = new Sprite();
         super.init();
      }
      
      override protected function onProppertiesUpdate() : void
      {
         super.onProppertiesUpdate();
         if((_changedPropeties[Component.P_height] || _changedPropeties[Component.P_width]) && this._backgound != null)
         {
            this._backgound.width = _width;
            this._backgound.height = _height;
            this.updateClosePos();
         }
         if(_changedPropeties[Component.P_height] || _changedPropeties[Component.P_width] || _changedPropeties[P_moveInnerRect])
         {
            this.updateMoveRect();
         }
         if(_changedPropeties[P_closeButton])
         {
            this._closeButton.addEventListener(MouseEvent.CLICK,this.__onCloseClick);
         }
         if(_changedPropeties[P_closeButton] || _changedPropeties[P_closeInnerRect])
         {
            this.updateClosePos();
         }
         if(_changedPropeties[P_containerX] || _changedPropeties[P_containerY])
         {
            this.updateContainerPos();
         }
         if(_changedPropeties[P_titleOuterRectPos] || _changedPropeties[P_titleText] || _changedPropeties[Component.P_height] || _changedPropeties[Component.P_width])
         {
            if(this._title != null)
            {
               this._title.text = this._titleText;
            }
            this.updateTitlePos();
         }
         if(_changedPropeties[P_moveEnable])
         {
            if(this._moveEnable)
            {
               this._moveRect.addEventListener(MouseEvent.MOUSE_DOWN,this.__onFrameMoveStart);
            }
            else
            {
               this._moveRect.removeEventListener(MouseEvent.MOUSE_DOWN,this.__onFrameMoveStart);
            }
         }
         if(this._escEnable || this._enterEnable)
         {
            StageReferance.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.__onKeyDown);
         }
         else
         {
            StageReferance.stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.__onKeyDown);
         }
      }
      
      protected function updateClosePos() : void
      {
         if(this._closeButton && this._closeInnerRect)
         {
            DisplayUtils.layoutDisplayWithInnerRect(this._closeButton,this._closeInnerRect,_width,_height);
         }
      }
      
      protected function updateContainerPos() : void
      {
         this._container.x = this._containerX;
         this._container.y = this._containerY;
      }
      
      protected function updateMoveRect() : void
      {
         if(this._moveInnerRect == null)
         {
            return;
         }
         var _loc1_:Rectangle = this._moveInnerRect.getInnerRect(_width,_height);
         this._moveRect.graphics.clear();
         this._moveRect.graphics.beginFill(0,0);
         this._moveRect.graphics.drawRect(_loc1_.x,_loc1_.y,_loc1_.width,_loc1_.height);
         this._moveRect.graphics.endFill();
      }
      
      protected function updateTitlePos() : void
      {
         var _loc1_:Point = null;
         if(this._title == null)
         {
            return;
         }
         if(this._titleOuterRectPos == null)
         {
            return;
         }
         _loc1_ = this._titleOuterRectPos.getPos(this._title.width,this._title.height,_width,_height);
         this._title.x = _loc1_.x;
         this._title.y = _loc1_.y;
      }
      
      protected function __onMoveWindow(param1:MouseEvent) : void
      {
         if(DisplayUtils.isInTheStage(new Point(param1.localX,param1.localY),this))
         {
            param1.updateAfterEvent();
         }
         else
         {
            this.__onFrameMoveStop(null);
         }
      }
   }
}
