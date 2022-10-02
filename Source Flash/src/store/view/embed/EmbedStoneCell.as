package store.view.embed
{
   import bagAndInfo.cell.BagCell;
   import bagAndInfo.cell.DragEffect;
   import bagAndInfo.cell.LinkedBagCell;
   import baglocked.BaglockedManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.ShineObject;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.CellEvent;
   import ddt.manager.DragManager;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.view.tips.MultipleLineTip;
   import ddt.view.tips.OneLineTip;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import road7th.utils.MovieClipWrapper;
   import store.data.StoreModel;
   import store.events.EmbedBackoutEvent;
   import store.events.EmbedEvent;
   
   public class EmbedStoneCell extends LinkedBagCell
   {
      
      public static const FivePlaceInStoreBag:int = 1;
      
      public static const SixPlaceInStoreBag:int = 2;
      
      public static const Close:int = -1;
      
      public static const Empty:int = 0;
      
      public static const Full:int = 1;
      
      public static const ATTACK:int = 1;
      
      public static const DEFENSE:int = 2;
      
      public static const ATTRIBUTE:int = 3;
       
      
      private var _id:int;
      
      private var _state:int = -1;
      
      private var _stoneType:int;
      
      private var _shiner:ShineObject;
      
      private var _tipPanel:Sprite;
      
      private var _tipDerial:Boolean;
      
      private var tipSprite:Sprite;
      
      private var _tipOne:MultipleLineTip;
      
      private var _tipTwo:OneLineTip;
      
      private var _openGrid:ScaleFrameImage;
      
      private var _closeStrip:Bitmap;
      
      private var _holeLv:int = -1;
      
      private var _holeExp:int = -1;
      
      private var _closeTipsStrArr:Array;
      
      public function EmbedStoneCell(param1:int, param2:int)
      {
         this._closeTipsStrArr = [LanguageMgr.GetTranslation("tank.store.embedCell.close3"),LanguageMgr.GetTranslation("tank.store.embedCell.close6"),LanguageMgr.GetTranslation("tank.store.embedCell.close9"),LanguageMgr.GetTranslation("tank.store.embedCell.close12"),LanguageMgr.GetTranslation("tank.store.embedCell.closeOpenHole"),LanguageMgr.GetTranslation("tank.store.embedCell.closeOpenHole")];
         var _loc3_:Sprite = new Sprite();
         var _loc4_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.store.EmbedCellBG");
         _loc3_.addChild(_loc4_);
         super(_loc3_);
         this._id = param1;
         this._stoneType = param2;
         this._shiner = new ShineObject(ComponentFactory.Instance.creat("asset.store.EmbedStoneCellShine"));
         this._shiner.mouseChildren = this._shiner.mouseEnabled = this._shiner.visible = false;
         addChild(this._shiner);
         this._openGrid = ComponentFactory.Instance.creatComponentByStylename("store.EmbedOpenGrid");
         this._openGrid.setFrame(1);
         addChildAt(this._openGrid,0);
         if(this._id >= 5)
         {
            this._closeStrip = ComponentFactory.Instance.creatBitmap("asset.store.EmbedFiveSixGridClose");
         }
         else
         {
            this._closeStrip = ComponentFactory.Instance.creatBitmap("asset.store.EmbedGridClose");
         }
         addChild(this._closeStrip);
         DoubleClickEnabled = false;
         this.close();
         this._tipOne = ComponentFactory.Instance.creatCustomObject("store.multipleLineTip");
         this._tipTwo = ComponentFactory.Instance.creatCustomObject("store.embedStoneCellCloseTip");
         this._tipTwo.tipData = this._closeTipsStrArr[param1 - 1];
         this.initEvents();
      }
      
      public function holeLvUp() : void
      {
         var _loc1_:MovieClip = null;
         _loc1_ = null;
         _loc1_ = ClassUtils.CreatInstance("asset.store.embed.HoleExpUp");
         _loc1_.x = 25;
         _loc1_.y = 69;
         var _loc2_:MovieClipWrapper = new MovieClipWrapper(_loc1_,true,true);
         addChild(_loc2_.movie);
      }
      
      override public function get allowDrag() : Boolean
      {
         return false;
      }
      
      override public function dragStart() : void
      {
         if(_info && !locked && stage && this.allowDrag)
         {
            if(DragManager.startDrag(this,_info,createDragImg(),stage.mouseX,stage.mouseY,DragEffect.MOVE))
            {
               locked = true;
            }
         }
         if(_info && _pic.numChildren > 0)
         {
            dispatchEvent(new CellEvent(CellEvent.DRAGSTART,this.info,true));
         }
      }
      
      private function initEvents() : void
      {
         addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
      }
      
      override protected function onMouseOver(param1:MouseEvent) : void
      {
         if(this._state == Full && !this._tipDerial && info)
         {
            if(this._id > 4)
            {
               if(this._holeLv >= StoreModel.getHoleMaxOpLv())
               {
                  dispatchEvent(new EmbedBackoutEvent(EmbedBackoutEvent.EMBED_BACKOUT_DOWNITEM_OVER,this._id,info.TemplateID));
               }
            }
            else
            {
               dispatchEvent(new EmbedBackoutEvent(EmbedBackoutEvent.EMBED_BACKOUT_DOWNITEM_OVER,this._id,info.TemplateID));
            }
         }
         if(this._state != Close && _info == null)
         {
            this._tipOne.x = localToGlobal(new Point(width,height)).x + 8;
            this._tipOne.y = localToGlobal(new Point(width,height)).y + 8;
            LayerManager.Instance.addToLayer(this._tipOne,LayerManager.GAME_TOP_LAYER);
            return;
         }
         if(this._closeStrip.visible && _info == null)
         {
            this._tipTwo.x = localToGlobal(new Point(width,height)).x + 8;
            this._tipTwo.y = localToGlobal(new Point(width,height)).y + 8;
            LayerManager.Instance.addToLayer(this._tipTwo,LayerManager.GAME_TOP_LAYER);
         }
      }
      
      override protected function onMouseClick(param1:MouseEvent) : void
      {
         super.onMouseClick(param1);
      }
      
      private function onMouseDown(param1:MouseEvent) : void
      {
         if(info)
         {
            dispatchEvent(new EmbedBackoutEvent(EmbedBackoutEvent.EMBED_BACKOUT_DOWNITEM_DOWN,this._id,info.TemplateID));
         }
      }
      
      public function showTip(param1:MouseEvent) : void
      {
      }
      
      public function closeTip(param1:MouseEvent) : void
      {
         super.onMouseOut(param1);
      }
      
      override protected function onMouseOut(param1:MouseEvent) : void
      {
         if(this._state == Full && !this._tipDerial && _info != null)
         {
            dispatchEvent(new EmbedBackoutEvent(EmbedBackoutEvent.EMBED_BACKOUT_DOWNITEM_OUT,this._id,info.TemplateID));
         }
         if(this._state != Close && _info == null)
         {
            if(this._tipOne.parent)
            {
               this._tipOne.parent.removeChild(this._tipOne);
            }
            return;
         }
         if(this._closeStrip.visible && _info == null)
         {
            super.onMouseOut(param1);
            if(this._tipTwo.parent)
            {
               this._tipTwo.parent.removeChild(this._tipTwo);
            }
         }
      }
      
      public function open() : void
      {
         if(this._stoneType == -1)
         {
            return;
         }
         this._state = Empty;
         this._closeStrip.visible = false;
      }
      
      public function setHoleExp(param1:int) : void
      {
         this._holeExp = param1;
      }
      
      public function setHoleLv(param1:int) : void
      {
         this._holeLv = param1;
         if(this._holeLv >= 0 && this._stoneType == ATTRIBUTE && this._id > 4)
         {
            this._tipOne.tipData = LanguageMgr.GetTranslation("tank.store.embedCell.Hole",this._holeLv);
         }
      }
      
      public function set StoneType(param1:int) : void
      {
         var _loc2_:String = null;
         this._stoneType = param1;
         if(this._stoneType > 0)
         {
            this._openGrid.setFrame(this._stoneType);
         }
         switch(this._stoneType)
         {
            case ATTACK:
               _loc2_ = LanguageMgr.GetTranslation("tank.store.embedCell.attack");
               break;
            case DEFENSE:
               _loc2_ = LanguageMgr.GetTranslation("tank.store.embedCell.defense");
               break;
            case ATTRIBUTE:
               _loc2_ = LanguageMgr.GetTranslation("tank.store.embedCell.attribute");
               break;
            default:
               _loc2_ = null;
         }
         if(_loc2_)
         {
            this._tipOne.tipData = _loc2_;
         }
      }
      
      public function get StoneType() : int
      {
         return this._stoneType;
      }
      
      override public function set info(param1:ItemTemplateInfo) : void
      {
         super.info = param1;
         if(EquipType.isDrill(_info as InventoryItemInfo) && this._id > 5)
         {
            this._closeStrip.visible = false;
         }
         else if(_info)
         {
            if(_info.Property2 == "1" || _info.Property2 == "2" || _info.Property2 == "3")
            {
               this._state = Full;
            }
         }
      }
      
      public function close() : void
      {
         this._state = Close;
         this._closeStrip.visible = true;
         if(bagCell)
         {
            bagCell.locked = false;
            bagCell = null;
         }
         this.info = null;
         tipData = null;
      }
      
      override public function dragDrop(param1:DragEffect) : void
      {
         var _loc2_:InventoryItemInfo = null;
         var _loc3_:ItemTemplateInfo = null;
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(!(param1.source is EmbedBackoutButton))
         {
            if(this._state == Close)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.store.matte.notOpen"));
               return;
            }
         }
         else if(_info == null)
         {
            return;
         }
         if(param1.source is EmbedBackoutButton)
         {
            if(param1.action != DragEffect.SPLIT)
            {
               param1.action = DragEffect.NONE;
               DragManager.acceptDrag(this,DragEffect.LINK);
               dispatchEvent(new EmbedBackoutEvent(EmbedBackoutEvent.EMBED_BACKOUT,this._id,info.TemplateID));
               this._tipDerial = false;
            }
         }
         else
         {
            _loc2_ = param1.data as InventoryItemInfo;
            if(_loc2_ && param1.action != DragEffect.SPLIT)
            {
               param1.action = DragEffect.NONE;
               if(EquipType.isDrill(_loc2_))
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.fusion.AccessoryDragInArea.type"));
               }
               else if(EquipType.isBead(_loc2_))
               {
                  if(PlayerManager.Instance.Self.StoreBag.items[0] == null)
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.fusion.AccessoryDragInArea.type"));
                  }
                  else if(!this.isRightType(_loc2_))
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.store.matte.notType"));
                  }
                  else
                  {
                     _loc3_ = ItemManager.Instance.getTemplateById(_loc2_.TemplateID);
                     if(this._id == 5 && Math.floor((_loc3_.Level + 1) / 2) > InventoryItemInfo(PlayerManager.Instance.Self.StoreBag.items[0]).Hole5Level)
                     {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.store.matte.LevelWrong"));
                        return;
                     }
                     if(this._id == 6 && Math.floor((_loc3_.Level + 1) / 2) > InventoryItemInfo(PlayerManager.Instance.Self.StoreBag.items[0]).Hole6Level)
                     {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.store.matte.LevelWrong"));
                        return;
                     }
                     bagCell = param1.source as BagCell;
                     DragManager.acceptDrag(this,DragEffect.LINK);
                     dispatchEvent(new EmbedEvent(EmbedEvent.EMBED,this._id));
                     this._tipDerial = false;
                  }
               }
            }
         }
      }
      
      private function isRightType(param1:InventoryItemInfo) : Boolean
      {
         return param1.Property2 == this._stoneType.toString();
      }
      
      public function get tipDerial() : Boolean
      {
         return this._tipDerial;
      }
      
      public function set tipDerial(param1:Boolean) : void
      {
         this._tipDerial = param1;
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
      
      public function hasDrill() : Boolean
      {
         return EquipType.isDrill(_info as InventoryItemInfo);
      }
      
      override public function dispose() : void
      {
         removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         if(this._tipOne)
         {
            ObjectUtils.disposeObject(this._tipOne);
         }
         this._tipOne = null;
         if(this._tipTwo)
         {
            ObjectUtils.disposeObject(this._tipTwo);
         }
         this._tipTwo = null;
         if(this._shiner)
         {
            ObjectUtils.disposeObject(this._shiner);
         }
         this._shiner = null;
         if(this._openGrid)
         {
            ObjectUtils.disposeObject(this._openGrid);
         }
         this._openGrid = null;
         if(this._closeStrip)
         {
            ObjectUtils.disposeObject(this._closeStrip);
         }
         this._closeStrip = null;
         super.dispose();
      }
      
      public function get state() : int
      {
         return this._state;
      }
   }
}
