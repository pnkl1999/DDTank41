package quest
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.quest.QuestInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import ddt.manager.TaskManager;
   import flash.events.MouseEvent;
   
   public class NewQuestView extends Frame
   {
       
      
      private var contentBG:Scale9CornerImage;
      
      private var subTitle:FilterFrameText;
      
      private var frameTitle:FilterFrameText;
      
      private var itemList:VBox;
      
      private var scroll:ScrollPanel;
      
      private var mainFrame:TaskMainFrame;
      
      private var _questList:Array;
      
      private var _okBtn:TextButton;
      
      public function NewQuestView()
      {
         super();
         this.mainFrame = TaskManager.MainFrame;
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this.contentBG = ComponentFactory.Instance.creat("asset.quest.NewQuestFrameBG");
         addToContent(this.contentBG);
         this.frameTitle = ComponentFactory.Instance.creat("core.quest.NewQuestTitleText");
         this.frameTitle.text = LanguageMgr.GetTranslation("tank.view.quest.newquest.Title");
         addToContent(this.frameTitle);
         this.subTitle = ComponentFactory.Instance.creat("core.quest.NewQuestSubTitleText");
         this.subTitle.text = LanguageMgr.GetTranslation("tank.view.quest.newquest.Subtitle");
         addToContent(this.subTitle);
         this.itemList = new VBox();
         this.scroll = ComponentFactory.Instance.creat("core.quest.NewQuestScrollP");
         addToContent(this.scroll);
         this.scroll.setView(this.itemList);
         this._okBtn = ComponentFactory.Instance.creatComponentByStylename("core.simplebt");
         this._okBtn.text = LanguageMgr.GetTranslation("ok");
         this._okBtn.x = 150 - this._okBtn.width / 2;
         this._okBtn.y = 272;
         this._okBtn.addEventListener(MouseEvent.CLICK,this.__onClickOK);
         addToContent(this._okBtn);
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
      }
      
      private function __frameEventHandler(param1:FrameEvent) : void
      {
         switch(param1.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               this.__onClickOK(null);
			   break;
         }
      }
      
      public function update() : void
      {
         this.clearList();
         this.initData();
      }
      
      private function clearList() : void
      {
         this.itemList.disposeAllChildren();
      }
      
      private function initData() : void
      {
         var _loc2_:QuestInfo = null;
         var _loc3_:QuestInfo = null;
         var _loc4_:TaskPannelStripView = null;
         this._questList = new Array();
         var _loc1_:Array = TaskManager.newQuests;
         for each(_loc2_ in _loc1_)
         {
            if(_loc2_.Type != 2)
            {
               this._questList.push(_loc2_);
            }
         }
         for each(_loc3_ in this._questList)
         {
            _loc4_ = new TaskPannelStripView(_loc3_);
            _loc4_.addEventListener(MouseEvent.CLICK,this.__questStripClicked);
            this.itemList.addChild(_loc4_);
         }
      }
      
      private function __questStripClicked(param1:MouseEvent) : void
      {
         if(this.mainFrame.parent)
         {
            return;
         }
         this.clearList();
         TaskManager.selectedQuest = param1.target.info;
         this.mainFrame.switchVisible();
      }
      
      private function __onClickOK(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.dispose();
      }
      
      override public function dispose() : void
      {
         var _loc1_:TaskPannelStripView = null;
         removeEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         for each(_loc1_ in this.itemList)
         {
            _loc1_.removeEventListener(MouseEvent.CLICK,this.__questStripClicked);
            _loc1_.dispose();
            _loc1_ = null;
         }
         ObjectUtils.disposeObject(this.itemList);
         this.itemList = null;
         ObjectUtils.disposeObject(this.scroll);
         this.scroll = null;
         ObjectUtils.disposeObject(this.subTitle);
         this.subTitle = null;
         ObjectUtils.disposeObject(this.contentBG);
         this.contentBG = null;
         ObjectUtils.disposeObject(this.frameTitle);
         this.frameTitle = null;
         ObjectUtils.disposeObject(this._okBtn);
         this._okBtn = null;
         super.dispose();
      }
   }
}
