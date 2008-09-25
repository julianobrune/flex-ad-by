package by.ad
{
  /**
  * Direct reading of SWF file
  * Distributed under the new BSD License
  * @author ad@ad.by
  */
  public class SWF
  {
    import flash.display.LoaderInfo;
    import flash.utils.ByteArray;
    import flash.utils.Endian;

    ///////////////////////////////////////////////////////////////////////////
    // Returns compilation date of current module
    public static function readCompilationDate(): Date
    {
      const compilationDate: Date = new Date;
      const DATETIME_OFFSET: uint = 18;
      const src: ByteArray = readSerialNumber();

      // date stored as uint64
      src.position = DATETIME_OFFSET;
      src.endian = Endian.LITTLE_ENDIAN;
      compilationDate.time = src.readUnsignedInt() + src.readUnsignedInt() * (uint.MAX_VALUE + 1);

      return compilationDate;
    }

    ///////////////////////////////////////////////////////////////////////////
    // Returns contents of Adobe SerialNumber SWF tag
    public static function readSerialNumber(): ByteArray
    {
      const TAG_SERIAL_NUMBER: uint = 0x29;
      return findAndReadTagBody(TAG_SERIAL_NUMBER);
    }

    ///////////////////////////////////////////////////////////////////////////
    // Returns the tag body if it is possible
    private static function findAndReadTagBody(theTagCode: uint): ByteArray
    {
      const SWF_AVM2_HEADER_LENGTH: uint = 16;

      // getting direst access to unpacked SWF file
      const src: ByteArray = LoaderInfo.getLoaderInfoByDefinition(SWF).bytes;
      // skip AVM2 SWF header
      src.position = SWF_AVM2_HEADER_LENGTH;

      while (src.position < src.length)
        with (readTag(src, theTagCode))
      {
        if (tagCode == theTagCode)
          return tagBody;
      }

      return null;
    }

    ///////////////////////////////////////////////////////////////////////////
    // Returns tag from current read position
    private static function readTag(src: ByteArray, theTagCode: uint): Object
    {
      src.endian = Endian.LITTLE_ENDIAN;

      const tagCodeAndLength: uint = src.readUnsignedShort();
      const tagCode: uint = tagCodeAndLength >> 6;
      const tagLength: uint = function(): uint {
        const MAX_SHORT_TAG_LENGTH: uint = 0x3F;
        const shortLength: uint = tagCodeAndLength & MAX_SHORT_TAG_LENGTH;
        return (shortLength == MAX_SHORT_TAG_LENGTH) ? src.readUnsignedInt() : shortLength;
      }();

      const tagBody: ByteArray = new ByteArray;
      src.readBytes(tagBody, 0, tagLength);

      return {
        tagCode: tagCode,
        tagBody: tagBody
      };
    }
  }
}