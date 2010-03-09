package by.ad
{
  /**
  * GUID generation
  * Distributed under the new BSD License
  * @author ad@ad.by
  */
  public class GUID
  {
    import by.ad.SHA1;

    ///////////////////////////////////////////////////////////////////////////
    // GUID generation. Using the salt helps to increase randomization.
    public static function create(salt: String = ""): String
    {
      const id1: Number = new Date().getTime();
      const id2: Number = Math.random();
      const sha1str: String = SHA1.hex_sha1(id1 + id2 + salt);

      return sha1ToGUID(sha1str).toUpperCase();
    }

    ///////////////////////////////////////////////////////////////////////////
    // The GUID has the form "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
    // sha1 is 160 bit long - GUID is 128 bit only
    public static function sha1ToGUID(s: String): String
    {
      return [s.substr(0, 8), s.substr(8, 4), s.substr(12, 4), s.substr(16, 4), s.substr(20, 12)].join("-");
    }
  }
}