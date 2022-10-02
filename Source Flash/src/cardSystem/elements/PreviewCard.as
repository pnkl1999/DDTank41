package cardSystem.elements
{
   import cardSystem.data.CardInfo;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class PreviewCard extends Sprite implements Disposeable
   {
       
      
      private var _cardId:int;
      
      private var _cell:CardCell;
      
      private var _bg:Bitmap;
      
      private var _prop:FilterFrameText;
      
      private var _cardInfo:CardInfo;
      
      private var _cardName:FilterFrameText;
      
      public function PreviewCard()
      {
         super();
         this.initView();
      }
      
      public function get cardId() : int
      {
         return this._cardId;
      }
      
      public function set cardId(param1:int) : void
      {
         this._cardId = param1;
         this._cardName.text = ItemManager.Instance.getTemplateById(this.cardId).Name;
         this._cardName.y = 41 - this._cardName.textHeight / 2;
      }
      
      private function initView() : void
      {
         mouseChildren = false;
         mouseEnabled = false;
         var _loc1_:Sprite = new Sprite();
         _loc1_.graphics.beginFill(16777215,0);
         _loc1_.graphics.drawRect(0,0,57,70);
         _loc1_.graphics.endFill();
         this._cell = new CardCell(_loc1_);
         this._cell.starVisible = false;
         this._bg = ComponentFactory.Instance.creatBitmap("asset.cardCollect.storyCard.BG");
         this._prop = ComponentFactory.Instance.creatComponentByStylename("PreviewCard.Propset");
         this._cardName = ComponentFactory.Instance.creatComponentByStylename("PreviewCard.name");
         PositionUtils.setPos(this._cell,"PreviewCard.cellPos");
         addChild(this._bg);
         addChild(this._cardName);
         addChild(this._cell);
         addChild(this._prop);
      }
      
      public function set cardInfo(param1:CardInfo) : void
      {
         var _loc2_:String = "";
         if(param1)
         {
            this._cardInfo = param1;
            this._cell.cardInfo = param1;
            this._cell.visible = true;
            if(param1.templateInfo.Attack != 0)
            {
               _loc2_ = _loc2_.concat(LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.Attack",param1.realAttack) + "<br/>");
            }
            if(param1.templateInfo.Defence != 0)
            {
               _loc2_ = _loc2_.concat(LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.Defence",param1.realDefence) + "<br/>");
            }
            if(param1.templateInfo.Agility != 0)
            {
               _loc2_ = _loc2_.concat(LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.Agility",param1.realAgility) + "<br/>");
            }
            if(param1.templateInfo.Luck != 0)
            {
               _loc2_ = _loc2_.concat(LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.Luck",param1.realLuck) + "<br/>");
            }
            if(parseInt(param1.templateInfo.Property4) != 0)
            {
               _loc2_ = _loc2_.concat(LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.Damage",param1.realDamage) + "<br/>");
            }
            if(parseInt(param1.templateInfo.Property5) != 0)
            {
               _loc2_ = _loc2_.concat(LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.Guard",param1.realGuard) + "<br/>");
            }
         }
         else
         {
            this._cell.cardInfo = null;
            this._cell.visible = false;
            _loc2_ = LanguageMgr.GetTranslation("ddt.cardSystem.cardProp.unknown");
         }
         this._prop.htmlText = _loc2_;
      }
      
      override public function get width() : Number
      {
         return this._bg.width;
      }
      
      public function dispose() : void
      {
         this._cardInfo = null;
         ObjectUtils.disposeAllChildren(this);
         this._cell = null;
         this._bg = null;
         this._prop = null;
         this._cardName = null;
         if(this._bg)
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
