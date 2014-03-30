module ResponseHelper

  def returns_valid_response
    expect(response).to be_ok
  end

  def returns_valid_redirect
    expect(response).to be_redirect
  end

end