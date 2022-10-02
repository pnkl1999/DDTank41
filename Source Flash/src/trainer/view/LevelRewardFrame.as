package trainer.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.SelfInfo;
   import ddt.manager.PlayerManager;
   import ddt.manager.TaskManager;
   import ddt.view.character.CharactoryFactory;
   import ddt.view.character.ShowCharacter;
   import flash.display.Bitmap;
   import flash.geom.Point;
   import trainer.controller.WeakGuildManager;
   
   public class LevelRewardFrame extends BaseAlerFrame
   {
       
      
      private var _bg:Bitmap;
      
      private var _playerView:ShowCharacter;
      
      private var _up:Bitmap;
      
      private var _item1:LevelRewardItem;
      
      public function LevelRewardFrame()
      {
         super();
         this.initView();
         info = new AlertInfo();
         info.frameCenter = true;
         info.bottomGap = 16;
      }
      
      private function initView() : void
      {
         var _loc1_:SelfInfo = null;
         var _loc2_:Point = null;
         _loc1_ = null;
         this._bg = ComponentFactory.Instance.creatBitmap("asset.core.levelRewardBg1");
         addToContent(this._bg);
         _loc1_ = PlayerManager.Instance.Self;
         _loc2_ = ComponentFactory.Instance.creatCustomObject("core.levelReward.posPlayer");
         this._playerView = CharactoryFactory.createCharacter(_loc1_,CharactoryFactory.SHOW,true) as ShowCharacter;
         this._playerView.doAction(ShowCharacter.WIN);
         this._playerView.show(true,1,true);
         this._playerView.x = _loc2_.x;
         this._playerView.y = _loc2_.y;
         if(!_loc1_.getSuitesHide() && _loc1_.getSuitsType() == 1)
         {
            this._playerView.scaleX = this._playerView.scaleY = 1.3;
         }
         else
         {
            this._playerView.scaleX = this._playerView.scaleY = 1.4;
         }
         addToContent(this._playerView);
         this._up = ComponentFactory.Instance.creatBitmap("asset.core.levelRewardUp");
         addToContent(this._up);
      }
      
      private function showLv(param1:int) : void
      {
         var _loc6_:Bitmap = null;
         _loc6_ = null;
         var _loc2_:Array = param1.toString().split("");
         var _loc3_:int = this._up.x + (_loc2_.length > 1 ? 274 : 316);
         var _loc4_:int = this._up.y - 7;
         var _loc5_:int = 0;
         while(_loc5_ < _loc2_.length)
         {
            _loc6_ = ComponentFactory.Instance.creatBitmap("asset.core.levelRewardRed_" + _loc2_[_loc5_]);
            if(_loc2_.length <= 1)
            {
               _loc6_.x = 381;
            }
            else
            {
               _loc6_.x = 370 + _loc5_ * 25;
            }
            _loc6_.y = _loc4_;
            addToContent(_loc6_);
            _loc5_++;
         }
      }
      
      public function show(param1:int) : void
      {
         if(param1 > 15)
         {
            return;
         }
         this.level = param1;
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_TOP_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      public function hide() : void
      {
         this.dispose();
         if(WeakGuildManager.Instance.newTask)
         {
            TaskManager.showGetNewQuest();
            WeakGuildManager.Instance.newTask = false;
         }
      }
      
      public function set level(param1:int) : void
      {
         if(param1 > 15)
         {
            return;
         }
         this._item1 = ComponentFactory.Instance.creatCustomObject("core.levelRewardItem1");
         this._item1.setStyle(param1);
         addToContent(this._item1);
         this.showLv(param1);
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         this._playerView = null;
         this._up = null;
         if(this._item1)
         {
            this._item1.dispose();
            this._item1 = null;
         }
         super.dispose();
      }
   }
}
