package fightLib.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.PlayerManager;
   import flash.display.Sprite;
   
   public class FightLibView extends Sprite implements Disposeable
   {
       
      
      private var _playerInfoView:FightLibPlayerInfoView;
      
      private var _lessonsView:LessonsView;
      
      public function FightLibView()
      {
         super();
         this.configUI();
         this.hideGuide();
      }
      
      public function dispose() : void
      {
         if(this._playerInfoView)
         {
            ObjectUtils.disposeObject(this._playerInfoView);
            this._playerInfoView = null;
         }
         if(this._lessonsView)
         {
            ObjectUtils.disposeObject(this._lessonsView);
            this._lessonsView = null;
         }
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      public function startup() : void
      {
         this._playerInfoView.info = PlayerInfo(PlayerManager.Instance.Self);
      }
      
      public function hideGuide() : void
      {
         this._lessonsView.getGuild().stop();
         this._lessonsView.getGuild().visible = false;
      }
      
      public function showGuild(param1:int) : void
      {
         this._lessonsView.hideShine();
         if(!this._lessonsView.getGuild().visible)
         {
            this._lessonsView.getGuild().visible = true;
         }
         this._lessonsView.showShine(param1);
         this._lessonsView.getGuild().gotoAndStop(param1);
      }
      
      private function configUI() : void
      {
         this._playerInfoView = ComponentFactory.Instance.creatCustomObject("fightLib.view.FightLibPlayerInfoView");
         addChild(this._playerInfoView);
         this._lessonsView = ComponentFactory.Instance.creatCustomObject("fightLib.view.LessonsView");
         addChild(this._lessonsView);
      }
   }
}
