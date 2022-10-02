package noviceactivity
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import ddt.utils.PositionUtils;
   
   public class NoviceActivityRightView extends Sprite implements Disposeable
   {
       
      
      private var _bg:Bitmap;
      
      private var _title:String;
      
      private var _titleTxt:FilterFrameText;
      
      private var _detailTxt:FilterFrameText;
      
      private var _dateTxt:FilterFrameText;
      
      private var _conditionTitle:FilterFrameText;
      
      private var _awardTitle:FilterFrameText;
      
      private var _content:ScrollPanel;
      
      private var _vbox:VBox;
      
      private var _items:Array;
      
      private var _record:NoviceActivityInfo;
      
      private var _info:NoviceActivityInfo;
      
      private var _awards:Array;
      
      public function NoviceActivityRightView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.novice.rightview.bg");
         addChild(this._bg);
         this._titleTxt = ComponentFactory.Instance.creatComponentByStylename("noviceactivity.rightview.titleTxt");
         addChild(this._titleTxt);
         this._detailTxt = ComponentFactory.Instance.creatComponentByStylename("noviceactivity.rightview.detailTxt");
         addChild(this._detailTxt);
         this._dateTxt = ComponentFactory.Instance.creatComponentByStylename("noviceactivity.rightview.dateTxt");
         addChild(this._dateTxt);
         this._dateTxt.text = this.createDateText(NoviceActivityManager.instance.startDate) + "-" + this.createDateText(NoviceActivityManager.instance.endDate);
         this._conditionTitle = ComponentFactory.Instance.creatComponentByStylename("noviceactivity.rightview.itemtitleTxt");
         addChild(this._conditionTitle);
         this._conditionTitle.text = LanguageMgr.GetTranslation("noviceactivity.rightView.awardTitle.condition");
         PositionUtils.setPos(this._conditionTitle,"noviceactivity.rightview.conditiontitle.pos");
         this._awardTitle = ComponentFactory.Instance.creatComponentByStylename("noviceactivity.rightview.itemtitleTxt");
         addChild(this._awardTitle);
         this._awardTitle.text = LanguageMgr.GetTranslation("noviceactivity.rightView.awardTitle.award");
         PositionUtils.setPos(this._awardTitle,"noviceactivity.rightview.awardtitle.pos");
         this._items = [];
         this._content = ComponentFactory.Instance.creatComponentByStylename("noviceactiviy.rightview.itemlist");
         this._vbox = new VBox();
         this._vbox.spacing = 6;
         this._content.setView(this._vbox);
         this._content.vScrollProxy = ScrollPanel.ON;
         this._content.hScrollProxy = ScrollPanel.OFF;
         addChild(this._content);
      }
      
      private function initEvent() : void
      {
      }
      
      private function removeEvent() : void
      {
      }
      
      private function __updateViewItems(param1:Event) : void
      {
         var _loc2_:int = 0;
         var _loc3_:NoviceActivityRightAwardItem = null;
         if(this._items.length > 0)
         {
            _loc2_ = 0;
			
            while(_loc2_ < this._items.length)
            {
               _loc3_ = this._items[_loc2_] as NoviceActivityRightAwardItem;
               _loc3_.refreshBtn();
               _loc2_++;
            }
         }
      }
      
      private function addItem() : void
      {
         var _loc1_:int = 0;
         var _loc2_:NoviceActivityRightAwardItem = null;
         this._titleTxt.text = this._title;
         this._detailTxt.text = LanguageMgr.GetTranslation("noviceactivity.rightView.detailsTxt" + this._info.activityType);
         while(this._vbox.numChildren > 0 || this._items.length > 0)
         {
            this._vbox.disposeAllChildren();
            this._items.pop();
         }
         if(this._awards)
         {
            _loc1_ = 0;
            while(_loc1_ < this._awards.length)
            {
               _loc2_ = new NoviceActivityRightAwardItem();
			   
               _loc2_.setInfo(_loc1_,this._info.activityType,this._record,this._awards[_loc1_]);
               this._vbox.addChild(_loc2_);
               this._items.push(_loc2_);
               _loc1_++;
            }
         }
      }
      
      public function setInfo(param1:NoviceActivityInfo, param2:NoviceActivityInfo) : void
      {
         this._record = param1;
         this._info = param2;
         this._title = LanguageMgr.GetTranslation("noviceactivity.leftView.title.txt" + this._info.activityType);
         this._awards = this._info.awardList;
         this.addItem();
      }
      
      private function createDateText(param1:Date) : String
      {
         return param1.getFullYear() + "." + (param1.getMonth() + 1) + "." + param1.getDate();
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(this._bg)
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(this._titleTxt)
         {
            ObjectUtils.disposeObject(this._titleTxt);
         }
         this._titleTxt = null;
         if(this._detailTxt)
         {
            ObjectUtils.disposeObject(this._detailTxt);
         }
         this._detailTxt = null;
         if(this._dateTxt)
         {
            ObjectUtils.disposeObject(this._dateTxt);
         }
         this._dateTxt = null;
         if(this._conditionTitle)
         {
            ObjectUtils.disposeObject(this._conditionTitle);
         }
         this._conditionTitle = null;
         if(this._awardTitle)
         {
            ObjectUtils.disposeObject(this._awardTitle);
         }
         this._awardTitle = null;
         ObjectUtils.disposeAllChildren(this);
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
