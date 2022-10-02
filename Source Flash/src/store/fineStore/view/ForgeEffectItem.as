package store.fineStore.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.UICreatShortcut;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.utils.PositionUtils;
   import flash.display.Sprite;
   
   public class ForgeEffectItem extends Sprite implements Disposeable
   {
       
      
      private var _titleText:FilterFrameText;
      
      private var _content:Component;
      
      private var _stateText:FilterFrameText;
      
      public function ForgeEffectItem(param1:int, param2:String, param3:Array, param4:int)
      {
         var _loc5_:int = 0;
         var _loc6_:FilterFrameText = null;
         _loc5_ = 0;
         _loc6_ = null;
         super();
         var _loc7_:Image = ComponentFactory.Instance.creatComponentByStylename("fineSuit.tips.image");
         PositionUtils.setPos(_loc7_,"storeFine.tipsImagePos");
         addChild(_loc7_);
         _loc7_.setFrame(param1 + 1);
         this._content = ComponentFactory.Instance.creatComponentByStylename("storeFine.effect.titleContent");
         addChild(this._content);
         this._titleText = ComponentFactory.Instance.creatComponentByStylename("storeFine.effect.titleText");
         this._titleText.text = param2;
         this._content.addChild(this._titleText);
         _loc5_ = 0;
         while(_loc5_ < param3.length)
         {
            _loc6_ = UICreatShortcut.creatAndAdd("storeFine.effect.contentText",this);
            _loc6_.x = _loc5_ % 2 == 0 ? Number(Number(32)) : Number(Number(130));
            _loc6_.y = Math.ceil((_loc5_ + 1) / 2) * 19;
            _loc6_.text = param3[_loc5_];
            addChild(_loc6_);
            _loc5_++;
         }
         this.updateTipData();
         this.creatStateText(param4);
      }
      
      private function creatStateText(param1:int) : void
      {
         if(param1 > 0)
         {
            if(this._stateText)
            {
               ObjectUtils.disposeObject(this._stateText);
               this._stateText = null;
            }
            this._stateText = ComponentFactory.Instance.creatComponentByStylename("storeFine.cell.stateText" + param1);
            this._stateText.text = LanguageMgr.GetTranslation("storeFine.forge.state" + param1);
            addChild(this._stateText);
         }
      }
      
      public function updateTipData(param1:int = 0) : void
      {
         this._content.tipData = PlayerManager.Instance.Self.fineSuitExp;
         this.creatStateText(param1);
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._titleText);
         this._titleText = null;
         ObjectUtils.disposeObject(this._stateText);
         this._stateText = null;
         ObjectUtils.disposeAllChildren(this);
      }
   }
}
