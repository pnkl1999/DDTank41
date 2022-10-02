package worldboss.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Sprite;
   import worldboss.player.RankingPersonInfo;
   
   public class RankingPersonInfoItem extends Sprite implements Disposeable
   {
       
      
      private var _txtName:FilterFrameText;
      
      private var _txtDamage:FilterFrameText;
      
      private var _ranking:FilterFrameText;
      
      private var _num:int;
      
      private var _personInfo:RankingPersonInfo;
      
      private var _bg:ScaleFrameImage;
      
      private var _bgLine:MutipleImage;
      
      private var _longBg:Boolean;
      
      public function RankingPersonInfoItem(param1:int, param2:RankingPersonInfo, param3:Boolean = false)
      {
         super();
         this._num = param1;
         this._personInfo = param2;
         this._longBg = param3;
         this._init();
      }
      
      private function _init() : void
      {
         if(this._longBg)
         {
            this._bg = ComponentFactory.Instance.creatComponentByStylename("worldBossAward.rankingItemBg");
         }
         else
         {
            this._bg = ComponentFactory.Instance.creatComponentByStylename("worldboss.RankingItem.bg");
         }
         addChild(this._bg);
         if(this._num % 2 == 0)
         {
            this._bg.setFrame(1);
         }
         else
         {
            this._bg.setFrame(2);
         }
         this._bgLine = ComponentFactory.Instance.creatComponentByStylename("worldboss.ranking.ViewItemSeperators");
         addChild(this._bgLine);
         this._txtName = ComponentFactory.Instance.creat("worldBoss.ranking.name");
         addChild(this._txtName);
         this._txtDamage = ComponentFactory.Instance.creat("worldBoss.ranking.damage");
         addChild(this._txtDamage);
         this._ranking = ComponentFactory.Instance.creat("worldBoss.ranking.num");
         addChild(this._ranking);
         this.setValue();
      }
      
      private function setValue() : void
      {
         this._txtName.text = this._personInfo.name;
         this._txtDamage.text = this._personInfo.damage.toString();
         this._ranking.text = this._num.toString();
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         if(parent)
         {
            this.parent.removeChild(this);
         }
         this._bg = null;
         this._bgLine = null;
         this._txtName = null;
         this._txtDamage = null;
         this._ranking = null;
      }
   }
}
