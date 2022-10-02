package ddt.view.qqTips
{
   import calendar.CalendarManager;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.DesktopManager;
   import ddt.manager.PathManager;
   import ddt.manager.QQtipsManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import flash.external.ExternalInterface;
   import flash.geom.Point;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLVariables;
   import flash.net.navigateToURL;
   import flash.text.TextField;
   import flash.ui.Keyboard;
   import times.TimesManager;
   
   public class QQTipsView extends Sprite implements Disposeable
   {
       
      
      private var _qqInfo:QQTipsInfo;
      
      private var _bg:Bitmap;
      
      private var _closeBtn:BaseButton;
      
      private var _titleTxt:FilterFrameText;
      
      private var _outUrlTxt:TextField;
      
      protected var _moveRect:Sprite;
      
      public function QQTipsView()
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.core.QQtipsBG");
         this._closeBtn = ComponentFactory.Instance.creatComponentByStylename("coreIconQQ.closebt");
         this._titleTxt = ComponentFactory.Instance.creatComponentByStylename("coreIconQQ.titleTxt");
         this._outUrlTxt = ComponentFactory.Instance.creatCustomObject("coreIconQQ.QQOutUrlTxt");
         this._outUrlTxt.defaultTextFormat = ComponentFactory.Instance.model.getSet("coreIconQQ.qq.outTF");
         this._moveRect = new Sprite();
         addChild(this._bg);
         addChild(this._closeBtn);
         addChild(this._titleTxt);
         addChild(this._outUrlTxt);
         addChild(this._moveRect);
      }
      
      private function initEvents() : void
      {
         this._closeBtn.addEventListener(MouseEvent.CLICK,this.__colseClick);
         this._outUrlTxt.addEventListener(TextEvent.LINK,this.__onTextClicked);
         this._moveRect.addEventListener(MouseEvent.MOUSE_DOWN,this.__onFrameMoveStart);
         QQtipsManager.instance.addEventListener(QQtipsManager.COLSE_QQ_TIPSVIEW,this.__CloseView);
         StageReferance.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.__onKeyDown);
      }
      
      private function remvoeEvents() : void
      {
         if(this._closeBtn)
         {
            this._closeBtn.removeEventListener(MouseEvent.CLICK,this.__colseClick);
         }
         if(this._outUrlTxt)
         {
            this._outUrlTxt.removeEventListener(TextEvent.LINK,this.__onTextClicked);
         }
         if(this._moveRect)
         {
            this._moveRect.removeEventListener(MouseEvent.MOUSE_DOWN,this.__onFrameMoveStart);
         }
         QQtipsManager.instance.removeEventListener(QQtipsManager.COLSE_QQ_TIPSVIEW,this.__CloseView);
         StageReferance.stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.__onKeyDown);
      }
      
      private function __colseClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         ObjectUtils.disposeObject(this);
      }
      
      private function __CloseView(param1:Event) : void
      {
         ObjectUtils.disposeObject(this);
      }
      
      private function __onKeyDown(param1:KeyboardEvent) : void
      {
         var _loc2_:DisplayObject = StageReferance.stage.focus as DisplayObject;
         if(DisplayUtils.isTargetOrContain(_loc2_,this))
         {
            if(param1.keyCode == Keyboard.ESCAPE)
            {
               SoundManager.instance.play("008");
               ObjectUtils.disposeObject(this);
            }
         }
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
      
      public function set qqInfo(param1:QQTipsInfo) : void
      {
         this._qqInfo = param1;
         this._titleTxt.text = this._qqInfo.title;
         var _loc2_:String = "<a href=\"event:" + "clicktype:" + this._qqInfo.outInType + "\">" + this._qqInfo.content + "</a>";
         this._outUrlTxt.htmlText = _loc2_;
      }
      
      private function __onTextClicked(param1:TextEvent) : void
      {
         var _loc2_:URLRequest = new URLRequest(PathManager.solveRequestPath("LogClickTip.ashx"));
         var _loc3_:URLVariables = new URLVariables();
         _loc3_["title"] = this.qqInfo.title;
         _loc2_.data = _loc3_;
         var _loc4_:URLLoader = new URLLoader(_loc2_);
         _loc4_.load(_loc2_);
         _loc4_.addEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
         if(this.qqInfo.outInType == 0)
         {
            this.__playINmoudle();
         }
         else
         {
            SoundManager.instance.play("008");
            this.gotoPage("http://" + this.qqInfo.url);
         }
         ObjectUtils.disposeObject(this);
      }
      
      private function onIOError(param1:IOErrorEvent) : void
      {
      }
      
      private function __playINmoudle() : void
      {
         if(this.qqInfo.outInType == 0)
         {
            if(this.qqInfo.moduleType == QQTipsInfo.MODULE_TIMES)
            {
               TimesManager.Instance.showByQQtips(this.qqInfo.inItemID);
            }
            else if(this.qqInfo.moduleType == QQTipsInfo.MODULE_CALENDAR)
            {
               CalendarManager.getInstance().qqOpen(this.qqInfo.inItemID);
            }
            else if(this.qqInfo.moduleType == QQTipsInfo.MODULE_SHOP)
            {
               QQtipsManager.instance.gotoShop(this.qqInfo.inItemID);
            }
         }
      }
      
      private function gotoPage(param1:String) : void
      {
         var _loc2_:String = null;
         if(ExternalInterface.available && !DesktopManager.Instance.isDesktop)
         {
            _loc2_ = "function redict () {window.open(\"" + param1 + "\", \"_blank\")}";
            ExternalInterface.call(_loc2_);
         }
         else
         {
            navigateToURL(new URLRequest(encodeURI(param1)),"_blank");
         }
      }
      
      public function get qqInfo() : QQTipsInfo
      {
         return this._qqInfo;
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,false);
         StageReferance.stage.focus = this;
      }
      
      public function set moveRect(param1:String) : void
      {
         var _loc2_:Array = param1.split(",");
         this._moveRect.graphics.clear();
         this._moveRect.graphics.beginFill(0,0);
         this._moveRect.graphics.drawRect(_loc2_[0],_loc2_[1],_loc2_[2],_loc2_[3]);
         this._moveRect.graphics.endFill();
      }
      
      public function dispose() : void
      {
         this.remvoeEvents();
         this._qqInfo = null;
         if(this._bg)
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(this._closeBtn)
         {
            ObjectUtils.disposeObject(this._closeBtn);
         }
         this._closeBtn = null;
         if(this._titleTxt)
         {
            ObjectUtils.disposeObject(this._titleTxt);
         }
         this._titleTxt = null;
         if(this._outUrlTxt)
         {
            ObjectUtils.disposeObject(this._outUrlTxt);
         }
         this._outUrlTxt = null;
         if(this._moveRect)
         {
            ObjectUtils.disposeObject(this._moveRect);
         }
         this._moveRect = null;
         if(parent)
         {
            parent.removeChild(this);
         }
         QQtipsManager.instance.isShowTipNow = false;
      }
   }
}
