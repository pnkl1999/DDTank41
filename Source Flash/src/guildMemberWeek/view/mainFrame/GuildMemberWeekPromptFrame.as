package guildMemberWeek.view.mainFrame
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.events.MouseEvent;
   import guildMemberWeek.manager.GuildMemberWeekManager;
   
   public class GuildMemberWeekPromptFrame extends BaseAlerFrame
   {
       
      
      private var _txt:FilterFrameText;
      
      private var _Rankingtxt:FilterFrameText;
      
      private var _YesButton:TextButton;
      
      public function GuildMemberWeekPromptFrame()
      {
         super();
         this.initView();
         this.addEvent();
      }
      
      private function initView() : void
      {
         this._txt = ComponentFactory.Instance.creatComponentByStylename("guildMemberWeek.alert.txt");
         this._Rankingtxt = ComponentFactory.Instance.creatComponentByStylename("guildMemberWeek.alertRanking.txt");
         this._Rankingtxt.text = String(GuildMemberWeekManager.instance.model.MyRanking);
         this._YesButton = ComponentFactory.Instance.creatComponentByStylename("ddtstore.HelpFrame.EnterBtn");
         this._YesButton.text = LanguageMgr.GetTranslation("ok");
         this._YesButton.x = (430 - this._YesButton.width) / 2;
         this._YesButton.y = 118;
         addToContent(this._txt);
         addToContent(this._Rankingtxt);
         addToContent(this._YesButton);
      }
      
      private function addEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__response);
         this._YesButton.addEventListener(MouseEvent.CLICK,this.__yesClickHander);
      }
      
      private function removeEvents() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__response);
         this._YesButton.removeEventListener(MouseEvent.CLICK,this.__yesClickHander);
      }
      
      public function setPromptFrameTxt(param1:String) : void
      {
         this._txt.htmlText = param1;
      }
      
      private function __response(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            GuildMemberWeekManager.instance.CloseShowTop10PromptFrame();
         }
      }
      
      private function __yesClickHander(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         GuildMemberWeekManager.instance.CloseShowTop10PromptFrame();
      }
      
      override public function dispose() : void
      {
         this.removeEvents();
         while(numChildren)
         {
            ObjectUtils.disposeObject(getChildAt(0));
         }
         ObjectUtils.disposeAllChildren(this);
         super.dispose();
         this._Rankingtxt = null;
         this._txt = null;
         this._YesButton = null;
         if(this._YesButton)
         {
            ObjectUtils.disposeObject(this._YesButton);
         }
         this._YesButton = null;
      }
   }
}
