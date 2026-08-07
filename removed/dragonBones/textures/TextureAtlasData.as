package dragonBones.textures
{
   import dragonBones.core.BaseObject;
   import dragonBones.core.DragonBones;
   import flash.display.BitmapData;
   
   public class TextureAtlasData extends BaseObject
   {
      
      public var autoSearch:Boolean;
      
      public var scale:Number;
      
      public var width:Number;
      
      public var height:Number;
      
      public var name:String;
      
      public var imagePath:String;
      
      public var bitmapData:BitmapData;
      
      public const textures:Object = {};
      
      public function TextureAtlasData(param1:TextureAtlasData)
      {
         super(this);
         if(param1 != this)
         {
            throw new Error(DragonBones.ABSTRACT_CLASS_ERROR);
         }
      }
      
      override protected function _onClear() : void
      {
         var _loc1_:String = null;
         for(_loc1_ in this.textures)
         {
            (this.textures[_loc1_] as TextureData).returnToPool();
            delete this.textures[_loc1_];
         }
         this.autoSearch = false;
         this.scale = 1;
         this.width = 0;
         this.height = 0;
         this.name = null;
         this.imagePath = null;
         if(this.bitmapData)
         {
            this.bitmapData.dispose();
            this.bitmapData = null;
         }
      }
      
      public function generateTexture() : TextureData
      {
         throw new Error(DragonBones.ABSTRACT_METHOD_ERROR);
      }
      
      public function addTexture(param1:TextureData) : void
      {
         if(param1 && param1.name && !this.textures[param1.name])
         {
            this.textures[param1.name] = param1;
            param1.parent = this;
            return;
         }
         throw new ArgumentError();
      }
      
      public function getTexture(param1:String) : TextureData
      {
         return this.textures[param1] as TextureData;
      }
      
      public function copyFrom(param1:TextureAtlasData) : void
      {
         var _loc2_:String = null;
         var _loc3_:TextureData = null;
         this.autoSearch = param1.autoSearch;
         this.scale = param1.scale;
         this.width = param1.width;
         this.height = param1.height;
         this.name = param1.name;
         this.imagePath = param1.imagePath;
         for(_loc2_ in this.textures)
         {
            this.textures[_loc2_].returnToPool();
            delete this.textures[_loc2_];
         }
         for(_loc2_ in param1.textures)
         {
            _loc3_ = this.generateTexture();
            _loc3_.copyFrom(param1.textures[_loc2_]);
            this.textures[_loc2_] = _loc3_;
         }
      }
   }
}

