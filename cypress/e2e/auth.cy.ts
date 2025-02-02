describe('Authentication', () => {
  beforeEach(() => {
    cy.visit('/')
  })

  it('should navigate to login page', () => {
    cy.get('a').contains('Connexion').click()
    cy.url().should('include', '/login')
    cy.get('h2').contains('Connexion à LocaMat').should('be.visible')
  })

  it('should navigate to register page', () => {
    cy.get('a').contains('Inscription').click()
    cy.url().should('include', '/register')
    cy.get('h2').contains('Créer un compte').should('be.visible')
  })

  it('should show validation errors on login form', () => {
    cy.visit('/login')
    cy.get('button[type="submit"]').click()
    cy.get('input[type="email"]:invalid').should('have.length', 1)
    cy.get('input[type="password"]:invalid').should('have.length', 1)
  })

  it('should show validation errors on register form', () => {
    cy.visit('/register')
    cy.get('button[type="submit"]').click()
    cy.get('input:invalid').should('have.length.gt', 0)
  })
})