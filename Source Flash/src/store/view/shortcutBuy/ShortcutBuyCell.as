package store.view.shortcutBuy
{
   import bagAndInfo.cell.BaseCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.ShineObject;
   import ddt.data.EquipType;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.LanguageMgr;
   import flash.display.Sprite;
   
   public class ShortcutBuyCell extends BaseCell
   {
       
      
      private var _selected:Boolean = false;
      
      private var _mcBg:ScaleFrameImage;
      
      private var _nameArr:Array;
      
      private var _shiner:ShineObject;
      
      private var _itemInfo:ItemTemplateInfo;
      
      public function ShortcutBuyCell(param1:ItemTemplateInfo)
      {
         this._nameArr = [LanguageMgr.GetTranslation("store.view.ShortcutBuyCell.lingju"),LanguageMgr.GetTranslation("store.view.ShortcutBuyCell.jiezi"),LanguageMgr.GetTranslation("store.view.ShortcutBuyCell.shouzhuo"),LanguageMgr.GetTranslation("store.view.ShortcutBuyCell.baozhu"),LanguageMgr.GetTranslation("store.view.ShortcutBuyCell.zhuque"),LanguageMgr.GetTranslation("store.view.ShortcutBuyCell.xuanwu"),LanguageMgr.GetTranslation("store.view.ShortcutBuyCell.qinglong"),LanguageMgr.GetTranslation("store.view.ShortcutBuyCell.baihu")];
         var _loc2_:Sprite = new Sprite();
         _loc2_.addChild(ComponentFactory.Instance.creatBitmap("asset.store.EquipCellBG"));
         super(_loc2_);
         tipDirctions = "7,0";
         this._itemInfo = param1;
         this.initII();
      }
      
      private function initII() : void
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         this._mcBg = ComponentFactory.Instance.creatComponentByStylename("store.StoreShortcutCellBg");
         this._mcBg.visible = false;
         this._mcBg.setFrame(1);
         addChildAt(this._mcBg,0);
         this._shiner = new ShineObject(ComponentFactory.Instance.creat("asset.store.cellShine"));
         this._shiner.mouseChildren = this._shiner.mouseEnabled = this._shiner.visible = false;
         addChildAt(this._shiner,1);
         var _loc1_:FilterFrameText = ComponentFactory.Instance.creatComponentByStylename("store.ShortCutTxt");
         _loc1_.mouseEnabled = false;
         if(EquipType.isComposeStone(this._itemInfo))
         {
            _loc1_.text = LanguageMgr.GetTranslation("store.view.ShortcutBuyCell.Stone" + this._itemInfo.Property3);
         }
         else
         {
            _loc2_ = "";
            _loc3_ = 0;
            while(_loc3_ < this._nameArr.length)
            {
               if(this._itemInfo.Name.indexOf(this._nameArr[_loc3_]) > 0)
               {
                  _loc2_ = this._nameArr[_loc3_];
                  break;
               }
               _loc3_++;
            }
            _loc1_.text = _loc2_;
         }
         addChild(_loc1_);
         if(_loc1_.text == "")
         {
            this._mcBg.x = -3;
            this._mcBg.y = -3;
         }
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function set selected(param1:Boolean) : void
      {
         if(this._selected == param1)
         {
            return;
         }
         this._selected = param1;
         if(this._selected)
         {
            this._mcBg.setFrame(2);
         }
         else
         {
            this._mcBg.setFrame(1);
         }
      }
      
      public function startShine() : void
      {
         this._shiner.visible = true;
         this._shiner.shine();
      }
      
      public function stopShine() : void
      {
         this._shiner.stopShine();
         this._shiner.visible = false;
      }
      
      public function showBg() : void
      {
         this._mcBg.visible = true;
      }
      
      public function hideBg() : void
      {
         this._mcBg.visible = false;
      }
      
      override public function dispose() : void
      {
         if(this._shiner)
         {
            ObjectUtils.disposeObject(this._shiner);
         }
         this._shiner = null;
         if(this._mcBg)
         {
            ObjectUtils.disposeObject(this._mcBg);
         }
         this._mcBg = null;
         this._itemInfo = null;
         this._nameArr = null;
         ObjectUtils.disposeAllChildren(this);
         super.dispose();
      }
   }
}
