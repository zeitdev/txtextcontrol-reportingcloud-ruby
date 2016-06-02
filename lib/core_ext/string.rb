# Extensions to class String.
# @author Thorsten Kummerow
class String

  # Removes the first and last characters from a string and returns the 
  # manipulated string.
  # @return [String] The string without its first and last characters.
  def remove_first_and_last 
    if self.length == 0 then return '' end
    result = self.dup
    result[0] = ''
    if result.length > 0 then result[result.length - 1] = '' end
    return result
  end
end
