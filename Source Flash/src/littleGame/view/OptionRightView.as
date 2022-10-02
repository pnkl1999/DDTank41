package littleGame.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.ChatManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import littleGame.LittleGameManager;
   
   public class OptionRightView extends Sprite implements Disposeable
   {
       
      
      private var _bg:Scale9CornerImage;
      
      private var _bgII:MutipleImage;
      
      private var _title:Bitmap;
      
      private var _listView:LittleAwardListView;
      
      private var _pointTable:Bitmap;
      
      private var _pointTxt:FilterFrameText;
      
      private var _btnGoback:BaseButton;
      
      private var _btnEnter:BaseButton;
      
      public function OptionRightView()
      {
         super();
         this.initView();
         this.addEvent();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("littleGame.rightViewBg");
         addChild(this._bg);
         this._bgII = ComponentFactory.Instance.creatComponentByStylename("littleGame.rightViewBgII");
         addChild(this._bgII);
         this._title = ComponentFactory.Instance.creatBitmap("asset.littleGame.rightTitle");
         addChild(this._title);
         this._pointTxt = ComponentFactory.Instance.creatComponentByStylename("littleGame.pointTxt");
         addChild(this._pointTxt);
         this._pointTxt.text = PlayerManager.Instance.Self.Score.toString();
         this._btnGoback = ComponentFactory.Instance.creatComponentByStylename("littleGame.btnGobackHot");
         addChild(this._btnGoback);
         this._btnEnter = ComponentFactory.Instance.creatComponentByStylename("littleGame.btnEnterGame");
         addChild(this._btnEnter);
         this._listView = ComponentFactory.Instance.creatCustomObject("littleGame.awardList");
         addChild(this._listView);
      }
      
      private function addEvent() : void
      {
         this._btnGoback.addEventListener(MouseEvent.CLICK,this.__btnGobackClick);
         this._btnEnter.addEventListener(MouseEvent.CLICK,this.__btnEnterClick);
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.onChange);
      }
      
      private function onChange(event:PlayerPropertyEvent) : void
      {
         if(event.changedProperties["Score"])
         {
            this._pointTxt.text = PlayerManager.Instance.Self.Score.toString();
         }
      }
      
      private function __btnGobackClick(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         StateManager.setState(StateType.MAIN);
      }
      
      private function __btnEnterClick(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.Grade >= PathManager.LittleGameMinLv)
         {
            this._btnEnter.mouseEnabled = false;
            LittleGameManager.Instance.enterWorld();
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("littlegame.MinLvNote",PathManager.LittleGameMinLv));
            ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("littlegame.MinLvNote",PathManager.LittleGameMinLv));
         }
      }
      
      private function removeEvent() : void
      {
         this._btnGoback.removeEventListener(MouseEvent.CLICK,this.__btnGobackClick);
         this._btnEnter.removeEventListener(MouseEvent.CLICK,this.__btnEnterClick);
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.onChange);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(this._bg)
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(this._bgII)
         {
            ObjectUtils.disposeObject(this._bgII);
         }
         this._bgII = null;
         if(this._title)
         {
            ObjectUtils.disposeObject(this._title);
         }
         this._title = null;
         if(this._pointTxt)
         {
            ObjectUtils.disposeObject(this._pointTxt);
         }
         this._pointTxt = null;
         if(this._btnGoback)
         {
            ObjectUtils.disposeObject(this._btnGoback);
         }
         this._btnGoback = null;
         if(this._btnEnter)
         {
            ObjectUtils.disposeObject(this._btnEnter);
         }
         this._btnEnter = null;
         if(this._listView)
         {
            ObjectUtils.disposeObject(this._listView);
         }
         this._listView = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
