describe('Profile Management', () => {
  beforeEach(() => {
    cy.login('test@example.com', 'password123')
    cy.visit('/app/profile')
  })

  it('should display user profile information', () => {
    cy.contains('Mon profil').should('be.visible')
    cy.contains('Email').should('be.visible')
    cy.contains('Matricule').should('be.visible')
    cy.contains('Rôle').should('be.visible')
  })

  it('should enable profile editing', () => {
    cy.get('button').contains('Modifier').click()
    cy.get('input[name="first_name"]').should('be.enabled')
    cy.get('input[name="last_name"]').should('be.enabled')
    cy.get('input[name="phone"]').should('be.enabled')
  })

  it('should validate form fields', () => {
    cy.get('button').contains('Modifier').click()
    cy.get('input[name="phone"]').clear().type('invalid')
    cy.get('button').contains('Enregistrer').click()
    cy.contains('Numéro de téléphone invalide').should('be.visible')
  })

  it('should cancel editing', () => {
    cy.get('button').contains('Modifier').click()
    cy.get('input[name="first_name"]').clear().type('NewName')
    cy.get('button').contains('Annuler').click()
    cy.get('input[name="first_name"]').should('not.exist')
  })
})