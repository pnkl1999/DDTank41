package email.view
{
   import baglocked.BagLockedController;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.core.ITipedDisplay;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.LanguageMgr;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class DiamondOfWriting extends DiamondBase implements ITipedDisplay
   {
       
      
      private var _cellGoodsID:int;
      
      private var _annex:ItemTemplateInfo;
      
      private var _bagLocked:BagLockedController;
      
      private var _tipStyle:String;
      
      private var _tipData:Object;
      
      private var _tipDirctions:String;
      
      private var _tipGapV:int;
      
      private var _tipGapH:int;
      
      public function DiamondOfWriting()
      {
         super();
         this.tipStyle = "ddt.view.tips.OneLineTip";
         this.tipDirctions = "0";
         this.tipGapV = 5;
         this.tipData = LanguageMgr.GetTranslation("tank.view.emailII.WritingView.annex.tip");
         ShowTipManager.Instance.addTip(this);
      }
      
      public function get annex() : ItemTemplateInfo
      {
         return this._annex;
      }
      
      public function set annex(value:ItemTemplateInfo) : void
      {
         this._annex = value;
      }
      
      override protected function initView() : void
      {
         super.initView();
         mouseEnabled = true;
         mouseChildren = true;
         buttonMode = true;
         _cell.visible = true;
         _cell.allowDrag = true;
      }
      
      override protected function update() : void
      {
         if(this._annex == null)
         {
            centerMC.setFrame(1);
            centerMC.visible = true;
         }
         _cell.info = this._annex;
      }
      
      override protected function addEvent() : void
      {
         _cell.addEventListener(Event.CHANGE,this.__dragInBag);
         addEventListener(MouseEvent.CLICK,this.__click);
      }
      
      override protected function removeEvent() : void
      {
         _cell.removeEventListener(Event.CHANGE,this.__dragInBag);
         removeEventListener(MouseEvent.CLICK,this.__click);
      }
      
      public function setBagUnlock() : void
      {
         _cell.clearLinkCell();
      }
      
      private function __click(event:MouseEvent) : void
      {
         dispatchEvent(new EmailEvent(EmailEvent.SHOW_BAGFRAME));
         if(this._annex)
         {
            _cell.dragStart();
         }
      }
      
      private function __dragInBag(event:Event) : void
      {
         this.annex = _cell.info;
         if(this.annex)
         {
            dispatchEvent(new EmailEvent(EmailEvent.DRAGIN_ANNIEX));
         }
         else
         {
            dispatchEvent(new EmailEvent(EmailEvent.DRAGOUT_ANNIEX));
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this._annex = null;
         this._bagLocked;
         ShowTipManager.Instance.removeTip(this);
      }
      
      public function get tipStyle() : String
      {
         return this._tipStyle;
      }
      
      public function get tipData() : Object
      {
         return this._tipData;
      }
      
      public function get tipDirctions() : String
      {
         return this._tipDirctions;
      }
      
      public function get tipGapV() : int
      {
         return this._tipGapV;
      }
      
      public function get tipGapH() : int
      {
         return this._tipGapH;
      }
      
      public function set tipStyle(value:String) : void
      {
         if(this._tipStyle == value)
         {
            return;
         }
         this._tipStyle = value;
      }
      
      public function set tipData(value:Object) : void
      {
         if(this._tipData == value)
         {
            return;
         }
         this._tipData = value;
      }
      
      public function set tipDirctions(value:String) : void
      {
         if(this._tipDirctions == value)
         {
            return;
         }
         this._tipDirctions = value;
      }
      
      public function set tipGapV(value:int) : void
      {
         if(this._tipGapV == value)
         {
            return;
         }
         this._tipGapV = value;
      }
      
      public function set tipGapH(value:int) : void
      {
         if(this._tipGapH == value)
         {
            return;
         }
         this._tipGapH = value;
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
   }
}
